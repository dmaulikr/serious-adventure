#import <objc/runtime.h>
#import "CCTMXMapInfo+TMXParserExt.h"
#import "CCTMXObjectGroup.h"
@implementation CCTMXMapInfo (TMXParserExt)
+(void) applyParserExtensionSelector:(SEL)originalSelector withSelector:(SEL)newSelector
{

    Method originalMethod = class_getInstanceMethod([CCTMXMapInfo class], originalSelector);
    Method categoryMethod = class_getInstanceMethod([CCTMXMapInfo class], newSelector);
    method_exchangeImplementations(originalMethod, categoryMethod);
}
+(void) applyParserExtension
{
    [self applyParserExtensionSelector:@selector(parser:didStartElement:namespaceURI:qualifiedName:attributes:) withSelector:@selector(TMXParserExt_parser:didStartElement:namespaceURI:qualifiedName:attributes:)];
}
-(void) TMXParserExt_parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"polygon"])
    {
        // find parent object's dict and add polygon-points to it
        CCTMXObjectGroup *objectGroup = [objectGroups_ lastObject];
        NSMutableDictionary *dict = [[objectGroup objects] lastObject];
        [dict setValue:[attributeDict valueForKey:@"points"] forKey:@"polygonPoints"];
    } else {
        // call superclass method
        [self TMXParserExt_parser:parser didStartElement:elementName namespaceURI:namespaceURI qualifiedName:qName attributes:attributeDict];
    }
}
@end