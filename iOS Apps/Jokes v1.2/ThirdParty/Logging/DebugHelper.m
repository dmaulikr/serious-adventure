//
//  DebugHelper.m
//  SamoletikiPrototype
//
//  Created by Konstantin Sokolinskyi on 10/17/10.
//  Copyright 2010 SROST studio. All rights reserved.
//

#import <mach/mach_host.h>
#import <sys/sysctl.h>

#import "DebugHelper.h"

@implementation DebugHelper

static double gLastCallFreeMem = 0.0;

+ ( void ) dumpDictionary: ( NSDictionary* ) dict
{
	if ( nil == dict )
	{
		error( @"nill dict supplied" );
		return;
	}
	
	if ( ![dict isKindOfClass: [NSDictionary class]] )
	{
		error( @"object supplied is not of class NSDictionary");
		return;
	}
	
	if ( 0 == [dict count] )
	{
		error( @"empty dictionary" );
		return;
	}
	
	NSArray *keys = [dict allKeys];
	for ( NSString *key in keys )
	{
		debug( @"%@ -> %@", key, [dict objectForKey: key] );
	}
	
	debug( @"------" );
}

+ ( void ) dumpArray: ( NSArray* ) array
{
	if ( nil == array )
	{
		error( @"nill array supplied" );
		return;
	}
	
	if ( ![array isKindOfClass: [NSArray class]] )
	{
		error( @"object supplied is not of class NSArray");
		return;
	}
	
	if ( 0 == [array count] )
	{
		error( @"empty array" );
		return;
	}
		
	for ( NSObject *obj in array )
	{
		debug( @"%@", obj );
	}
	debug( @"------" );
}


+ ( void ) dumpRect: ( CGRect ) rect
{
	[DebugHelper dumpRect: rect withMessage: nil];
}


+ ( void ) dumpRect: ( CGRect ) rect withMessage: ( NSString* ) msg
{
	debug( @"%@: x: %f y: %f width: %f height: %f",
		  ( nil == msg ? @"rect" : msg ),
		  rect.origin.x,
		  rect.origin.y,
		  rect.size.width,
		  rect.size.height);
}


+ ( void ) logMemoryUsage
{
	error( @"%@", [DebugHelper memoryUsage] );
}


+ ( NSString* ) memoryUsage
{
	size_t length;
	int mib[ 6 ];
	int result;
	double mbFactor = 1.0 / ( 1024.0 * 1024.0 );
	
    //Fix warning
	//NSString *output = [NSString stringWithString: @"Memory Info\n"];
    NSString *output = @"Memory Info\n";
	output = [output stringByAppendingString: @"-----------\n"];
	
	int pagesize;
	mib[ 0 ] = CTL_HW;
	mib[ 1 ] = HW_PAGESIZE;
	length = sizeof( pagesize );
	if ( sysctl( mib, 2, &pagesize, &length, NULL, 0 ) < 0 )
	{
		//perror("getting page size");
	}
	output = [output stringByAppendingFormat: @"Page size = %d bytes\n", pagesize];
	
	mach_msg_type_number_t count = HOST_VM_INFO_COUNT;
	
	vm_statistics_data_t vmstat;
	if ( host_statistics( mach_host_self(), HOST_VM_INFO, ( host_info_t )&vmstat, &count ) != KERN_SUCCESS )
	{
		output=[output stringByAppendingString: @"Failed to get VM statistics."];
	}
	
	double total = vmstat.wire_count + vmstat.active_count + vmstat.inactive_count + vmstat.free_count;
	double wired = vmstat.wire_count / total;
	double active = vmstat.active_count / total;
	double inactive = vmstat.inactive_count / total;
	double free = vmstat.free_count / total;
	double freeMb = vmstat.free_count * pagesize * mbFactor;
	
	output=[output stringByAppendingFormat: @"Total =    %8d pages\n\n", vmstat.wire_count + vmstat.active_count + vmstat.inactive_count + vmstat.free_count];
	output=[output stringByAppendingFormat: @"Wired =    %0.2f MB\n", vmstat.wire_count * pagesize * mbFactor];
	output=[output stringByAppendingFormat: @"Active =   %0.2f MB\n", vmstat.active_count * pagesize * mbFactor];
	output=[output stringByAppendingFormat: @"Inactive = %0.2f MB\n", vmstat.inactive_count * pagesize * mbFactor];
	output=[output stringByAppendingFormat: @"Free =     %0.2f MB\n", freeMb];
	output=[output stringByAppendingFormat: @"Total =    %0.2f MB\n\n", (vmstat.wire_count + vmstat.active_count + vmstat.inactive_count + vmstat.free_count) * pagesize * mbFactor];
	output=[output stringByAppendingFormat: @"Wired =    %0.0f of 100\n", wired * 100.0];
	output=[output stringByAppendingFormat: @"Active =   %0.0f of 100\n", active * 100.0];
	output=[output stringByAppendingFormat: @"Inactive = %0.0f of 100\n", inactive * 100.0];
	output=[output stringByAppendingFormat: @"Free =     %0.0f of 100\n\n", free * 100.0];
	output=[output stringByAppendingFormat: @"Free mem delta =     %0.2f MB\n\n", freeMb - gLastCallFreeMem];
	
	gLastCallFreeMem = freeMb;
	
	mib[ 0 ] = CTL_HW;
	mib[ 1 ] = HW_PHYSMEM;
	length = sizeof( result );
	if ( sysctl( mib, 2, &result, &length, NULL, 0 ) < 0 )
	{
		error( @"getting physical memory");
	}
	output=[output stringByAppendingFormat: @"Physical memory = %0.2f MB\n", result * mbFactor ];
	mib[0] = CTL_HW;
	mib[1] = HW_USERMEM;
	length = sizeof(result);
	if ( sysctl( mib, 2, &result, &length, NULL, 0 ) < 0 )
	{
		error( @"getting user memory");
	}
	output=[output stringByAppendingFormat: @"User memory =     %0.2f MB\n\n", result * mbFactor];
	
	return output;	
}


@end
