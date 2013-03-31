/**
 * Created with JetBrains WebStorm.
 * User: stry41802
 * Date: 31/03/13
 * Time: 7:56 AM
 * To change this template use File | Settings | File Templates.
 */
Ext.define('CRUD.route.horse', {
    /**
     * List the items in the Doc collection
     */
    list: function (req, res, next) {
        if (req.params.start && !req.params.limit) {
            next();
            return;
        }
        var store = Ext.create('Next.data.Store.Horse', {
            autoLoad: {
                skip: req.params.start,
                limit: req.params.limit,
                callback: function (records, operation, success) {
                    var _array = new Array();
                    Ext.Array.forEach(records, function (item) {
                        var data = item.data;
                        data[item.idProperty] = item.data._id.toString();
                        _array.push(data);
                    });
                    res.json(_array);
                }
            }
        });
    },
    /**
     * Count the items in the Doc collection
     */
    horseCount: function (req, res) {
        var store = Ext.create('Next.data.Store.Horse');
        store.load(function () {
            res.send(store.getTotalCount().toString());
        });
    },
    /**
     * Creates an item
     */
    post: function (req, res) {
        var model = Ext.create('Next.model.NoSQL.Horse');
        model.set(req.body);
        model.save({
            failure: function () {
                res.json({
                    'status': 'Unable to save the data'
                }, 500);
            },
            success: function () {
                res.json({'id' : this.get(this.idProperty.toString())});
            }
        });
    },
    /**
     * Retrieves an item by its id
     */
    get: function (req, res) {
        var store = Ext.create('Next.data.Store.Horse');
        store.getById(req.params.id, function (obj) {
            res.json(obj ? obj.data : null);
        });
    },
    /**
     * Updates an item by its id
     */
    put: function(req, res) {
        var store = Ext.create('Next.data.Store.Horse');
        store.getById(req.params.id, function (obj) {
            if (obj === null) {
                res.json({
                    'status': 'error',
                    'message' : 'No data with ID: ' + req.params.id
                }, 400);
            } else {
                var body = req.body;
                for (var idx in body) {
                    obj.set(idx, body[idx]);
                }
                obj.save();
                res.send(obj.data);
            }
        });
    },
    /**
     * Deletes an item by its id
     */
    delete: function (req, res) {
        var store = Ext.create('Next.data.Store.Horse');

        store.getById(req.params.id, function (obj) {
            if (obj === null) {
                res.json({
                    'status': 'error',
                    'message' : 'No data with ID: ' + req.params.id
                }, 400);
            } else {
                obj.destroy({
                    success: function() {
                        res.send(obj.data);
                    },
                    failure: function() {
                        res.json({
                            'status': 'Unable to save the data'
                        }, 500);
                    }
                });
            }
        });
    }
});

