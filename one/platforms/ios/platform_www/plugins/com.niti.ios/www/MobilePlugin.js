cordova.define("com.niti.ios.MobilePlugin", function(require, exports, module) {
var exec = require('cordova/exec');

exports.appraise = function (arg0, success, error) {
    exec(success, error, 'MobilePlugin', 'appraise', [arg0]);
};

});
