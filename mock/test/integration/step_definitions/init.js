/* jshint node:true */
'use strict';

var apickli = require('apickli');

module.exports = function() {
    this.Before(function(scenario, callback) {
        this.apickli = new apickli.Apickli("http", "${apigee.org}-${apigee.env}.apigee.net/mock");
        callback();
    });
};
