/**
 * Created with JetBrains WebStorm.
 * User: stry41802
 * Date: 30/03/13
 * Time: 6:08 PM
 * To change this template use File | Settings | File Templates.
 */
var express = require('express');
require('node-extjs4');

Ext.Loader.setConfig({
    enabled: true,
    paths: {
        'Next': './lib/Next',
        'CRUD': './lib/CRUD'
    }
});
Ext.require('Next.data.proxy.Mongo');
Ext.require('Next.data.Store.Horse');
Ext.require('Next.model.NoSQL.Horse');
//Ext.require('Next.router');

var application = express();
application.use(express.bodyParser());

var router = Ext.create('Next.router', {
    path: __dirname + '/config/routes.json',
    app: application
});
router.handle();
