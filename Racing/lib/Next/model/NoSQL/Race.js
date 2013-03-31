/**
 * Created with JetBrains WebStorm.
 * User: stry41802
 * Date: 30/03/13
 * Time: 6:42 PM
 * To change this template use File | Settings | File Templates.
 */

Ext.define('Next.model.NoSQL.Race', {
    extend: 'Ext.data.Model',
    requires: [
        'Next.data.proxy.Mongo',
        'Ext.data.Store'
    ],
    constructor: function () {
        this.callParent(arguments);
        this.store = new Ext.data.Store({
            model: Ext.getClassName(this)
        });
    },
    idProperty: '_id',
//    fields: [ //Optional. In Mongo we use Documents, not tables.
//        {name: 'number', type: 'int'}
//    ],
    proxy: {
        type: 'mongo',
        db: 'racingdata',
        collection: 'races',
        reader: {
            type: 'json'
        }
    },
    getId: function () {
        var objectID = this.callParent();
        if (objectID) {
            return objectID.toHexString();
        }
        return null;
    }
});

