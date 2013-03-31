/**
 * Created with JetBrains WebStorm.
 * User: stry41802
 * Date: 30/03/13
 * Time: 6:54 PM
 * To change this template use File | Settings | File Templates.
 */
Ext.define('Next.data.Store.Raceday', {
    extend: 'Ext.data.Store',
    model : 'Next.model.NoSQL.Raceday',
    constructor: function () {
        this.callParent(arguments);
    },
    getById: function(_id, callback) {
        var obj;
        if (this.isLoaded()) {
            obj = this.callParent([_id]);
        }
        if (obj) {
            (callback || Ext.emptyFn).call(this, obj);
        } else {
            var me = this,
                op = new Ext.data.Operation({
                    action: 'read',
                    callback: function(records, operation, success) {
                        (callback || EmptyFn).call(me, records[0]);
                    },
                    limit: 1,
                    scope: this,
                    criteria: {_id : this.getProxy().createObjectIDFromHexString(_id)}
                });
            this.read(op);
        }
    },
    isLoaded: function() {
        return typeof(this.totalCount) !== 'undefined';
    }
})
