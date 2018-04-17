// var app = new Framework7({  
//   // App root element
//   root: '#app',
//   // App Name
//   name: 'My App',
//   // App id
//   id: 'com.myapp.test',
//   // Enable swipe panel
//   panel: {
//     swipe: 'left',
//   },
//   // Add default routes
//   routes: [
//     {
//       path: '/about/',
//       url: 'about.html',
//     },
//   ],
//   // ... other parameters
// });

// var $$ = Dom7;

// var mainView = app.views.create('.view-main');



var app = new Framework7();

var $$ = Dom7;

// DOM events for About popup
$$('.popup-about').on('popup:open', function (e, popup) {
  console.log('About popup open');
});
$$('.popup-about').on('popup:opened', function (e, popup) {
  console.log('About popup opened');
});
$$('#pl').on('click',function(){
  console.log('appraise');
  cordova.plugins.MobilePlugin.appraise("appraise");
});
$$('#jc').on('click',function(){
  console.log('checkVersion');
  cordova.plugins.MobilePlugin.checkVersion("checkVersion",function(data) {
          alert(JSON.stringify(data));
  });
  
})




// Create dynamic Popup
var dynamicPopup = app.popup.create({
  content: '<div class="popup">'+
              '<div class="block">'+
                '<p>真诚感谢您的宝贵意见！</p>'+
                '<p><a href="#" class="link popup-close">您的反馈已提交，点我返回。</a></p>'+
              '</div>'+
            '</div>',
  // Events
  on: {
    open: function (popup) {
      console.log('Popup open');
    },
    opened: function (popup) {
      console.log('Popup opened');
    },
  }
});
$$('.dynamic-popup').on('click', function () {
  dynamicPopup.open();
});
var mainView = app.views.create('.view-main');
