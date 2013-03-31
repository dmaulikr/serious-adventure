/**
 * Created with JetBrains WebStorm.
 * User: stry41802
 * Date: 30/03/13
 * Time: 6:08 PM
 * To change this template use File | Settings | File Templates.
 */
var express = require('express');
  require('node-extjs4');

var app = express();
app.use(express.bodyParser());

Ext.Loader.setConfig({
    enabled: true,
    paths: {
        'Next': './lib/Next',
        'CRUD': './lib/CRUD'
    }
});

Ext.require(
    [
        'Next.data.proxy.Mongo',
        'Next.data.Store.Horse',
        'Next.model.NoSQL.Horse',
        'CRUD.routes.horse',
        'Next.router'
    ]
);

Ext.define('CRUD.routes.horse', {
    /**
     * List the items in the Doc collection
     */

    list: function(req, res, next) {
        if (req.params.start && !req.params.limit) {
            next();
            return;
        }
        var store = Ext.create('Next.data.Store.Horse', {
            autoLoad: {
                skip: req.params.start,
                limit: req.params.limit,
                callback: function(records, operation, success) {
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
    put: function (req, res) {
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
                    success: function () {
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





Ext.define('Next.router', {
    app: null,
    constructor: function (config) {
        if (!config.app) {
            Ext.Error.raise({
                msg: 'no Application provided'
            });
        }
        this.app = config.app;
        if (!config.path) {
            Ext.Error.raise({
                msg: 'no route file specified'
            });
        }
        this.routes = config.path;
    },
    handle: function () {
        var routeConfig,
            me = this;
        try {
            routeConfig = require(this.routes);
        } catch (e) {
            console.error(e);
            Ext.Error.raise({
                msg: e
            });
        }
        Ext.Array.each(routeConfig.routes, function (item, index, all) {
            var handler;
            if (item.handlerCls) {
                handler = Ext.create(item.handlerCls)[item.method];
            } else {
                var handlerConf = item.handler;
                handler = Ext.create(handlerConf.class)[handlerConf.method];
            }
            me.app[Ext.util.Format.lowercase(item.method)].call(me.app, item.route, handler);
        });
    }
});





var router = Ext.create('Next.router', {
    path: __dirname + '/config/routes.json',
    app: app
});
router.handle();

app.listen(3000);