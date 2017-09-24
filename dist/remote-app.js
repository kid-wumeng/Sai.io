(function webpackUniversalModuleDefinition(root, factory) {
	if(typeof exports === 'object' && typeof module === 'object')
		module.exports = factory(require("WebSocket"));
	else if(typeof define === 'function' && define.amd)
		define(["WebSocket"], factory);
	else if(typeof exports === 'object')
		exports["Sai"] = factory(require("WebSocket"));
	else
		root["Sai"] = factory(root["WebSocket"]);
})(this, function(__WEBPACK_EXTERNAL_MODULE_6__) {
return /******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};
/******/
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/
/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId]) {
/******/ 			return installedModules[moduleId].exports;
/******/ 		}
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			i: moduleId,
/******/ 			l: false,
/******/ 			exports: {}
/******/ 		};
/******/
/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);
/******/
/******/ 		// Flag the module as loaded
/******/ 		module.l = true;
/******/
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/
/******/
/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;
/******/
/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;
/******/
/******/ 	// define getter function for harmony exports
/******/ 	__webpack_require__.d = function(exports, name, getter) {
/******/ 		if(!__webpack_require__.o(exports, name)) {
/******/ 			Object.defineProperty(exports, name, {
/******/ 				configurable: false,
/******/ 				enumerable: true,
/******/ 				get: getter
/******/ 			});
/******/ 		}
/******/ 	};
/******/
/******/ 	// getDefaultExport function for compatibility with non-harmony modules
/******/ 	__webpack_require__.n = function(module) {
/******/ 		var getter = module && module.__esModule ?
/******/ 			function getDefault() { return module['default']; } :
/******/ 			function getModuleExports() { return module; };
/******/ 		__webpack_require__.d(getter, 'a', getter);
/******/ 		return getter;
/******/ 	};
/******/
/******/ 	// Object.prototype.hasOwnProperty.call
/******/ 	__webpack_require__.o = function(object, property) { return Object.prototype.hasOwnProperty.call(object, property); };
/******/
/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "";
/******/
/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(__webpack_require__.s = 1);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/***/ (function(module, exports, __webpack_require__) {

var rng = __webpack_require__(8);
var bytesToUuid = __webpack_require__(10);

function v4(options, buf, offset) {
  var i = buf && offset || 0;

  if (typeof(options) == 'string') {
    buf = options == 'binary' ? new Array(16) : null;
    options = null;
  }
  options = options || {};

  var rnds = options.random || (options.rng || rng)();

  // Per 4.4, set bits for version and `clock_seq_hi_and_reserved`
  rnds[6] = (rnds[6] & 0x0f) | 0x40;
  rnds[8] = (rnds[8] & 0x3f) | 0x80;

  // Copy bytes to buffer, if provided
  if (buf) {
    for (var ii = 0; ii < 16; ++ii) {
      buf[i + ii] = rnds[ii];
    }
  }

  return buf || bytesToUuid(rnds);
}

module.exports = v4;


/***/ }),
/* 1 */
/***/ (function(module, exports, __webpack_require__) {

var RemoteApp, Sai;

RemoteApp = __webpack_require__(2);

RemoteApp.adapter = {};

RemoteApp.adapter.isFile = function(value) {
  return value instanceof File;
};

RemoteApp.adapter.encodeFile = function(file, callback) {
  var reader;
  reader = new FileReader();
  reader.addEventListener('load', function() {
    var base64, dataUrl, fileString;
    dataUrl = reader.result;
    base64 = dataUrl.replace(/^data:.*;base64,/, '');
    fileString = `/File(${base64})/`;
    return callback(fileString);
  });
  return reader.readAsDataURL(file);
};

RemoteApp.adapter.decodeFile = function(fileString, callback) {
  var base64;
  base64 = fileString.slice(6, fileString.length - 2);
  return callback(base64);
};

Sai = {RemoteApp};

module.exports = Sai;


/***/ }),
/* 2 */
/***/ (function(module, exports, __webpack_require__) {

var Client, RPC, RemoteApp;

Client = __webpack_require__(3);

RPC = __webpack_require__(14);

module.exports = RemoteApp = class RemoteApp {
  /* options */
  // {number} timeout              - http 与 web-socket 请求超时时间，单位毫秒
  // {number} reconnectInterval    - web-socket 初始重连间隔，单位毫秒
  // {number} reconnectIntervalMax - web-socket 最大重连间隔，单位毫秒，即衰退极限
  // {number} reconnectDecay       - web-socket 重连衰退常数
  //#
  constructor(url, options = {}) {
    this.task = this.task.bind(this);
    options = Object.assign({
      timeout: 10000,
      reconnectInterval: 1000,
      reconnectIntervalMax: 30000,
      reconnectDecay: 1.5
    }, options);
    this.client = new Client(url, RemoteApp.adapter, options);
    this.rpc = new RPC(this.client);
  }

  call(method, ...params) {
    return this.rpc.call(method, params);
  }

  callBatch(tasks) {
    return this.rpc.callBatch(tasks);
  }

  callSeq(tasks) {
    return this.rpc.callSeq(tasks);
  }

  callParal(tasks) {
    return this.rpc.callParal(tasks);
  }

  task(method, ...params) {
    return this.rpc.task(method, params);
  }

  on(event, callback) {
    if (!['open', 'close', 'error'].includes(event)) {
      throw 'Sorry, your only listen the {open}, {close} or {error} event.';
    }
    return this.client.on(event, callback);
  }

};


/***/ }),
/* 3 */
/***/ (function(module, exports, __webpack_require__) {

var Client, WebSocket;

WebSocket = __webpack_require__(4);

module.exports = Client = class Client {
  constructor(url, adapter, options) {
    this.webSocket = new WebSocket(url, adapter, options);
  }

  send(packet, callback) {
    return this.webSocket.send(packet, callback);
  }

};


/***/ }),
/* 4 */
/***/ (function(module, exports, __webpack_require__) {

var PostOffice, Socket, WebSocket;

Socket = __webpack_require__(5);

PostOffice = __webpack_require__(7);

module.exports = WebSocket = class WebSocket {
  constructor(url, adapter, options) {
    this.socket = new Socket(url, adapter, options);
    this.postOffice = new PostOffice(this.socket, adapter);
  }

  send(packet, callback) {
    return this.postOffice.send(packet, callback);
  }

};


/***/ }),
/* 5 */
/***/ (function(module, exports, __webpack_require__) {

var Socket, WebSocket;

WebSocket = __webpack_require__(6);

module.exports = Socket = class Socket {
  constructor(url, adapter, options) {
    this.connect = this.connect.bind(this);
    this.reconnect = this.reconnect.bind(this);
    /* @private */
    // 计算某次重连的延时
    //#
    this.computeReconnectDelay = this.computeReconnectDelay.bind(this);
    this.handleOpen = this.handleOpen.bind(this);
    this.handleClose = this.handleClose.bind(this);
    this.handleError = this.handleError.bind(this);
    this.handleMessage = this.handleMessage.bind(this);
    this.sendFirst = this.sendFirst.bind(this);
    this.send = this.send.bind(this);
    this.on = this.on.bind(this);
    this.addEventListener = this.addEventListener.bind(this);
    this.url = url;
    this.adapter = adapter;
    this.reconnectInterval = options.reconnectInterval;
    this.reconnectIntervalMax = options.reconnectIntervalMax;
    this.reconnectDecay = options.reconnectDecay;
    this.reconnectCount = 0;
    this.reconnectTimer = null;
    this.ws = null;
    this.isOpen = false;
    this.first = true;
    this.firstMessages = [];
    this.readyMessages = [];
    this.openCallbacks = [];
    this.closeCallbacks = [];
    this.errorCallbacks = [];
    this.messageCallbacks = [];
    this.connect();
  }

  connect() {
    this.isOpen = false;
    this.ws = new WebSocket(this.url);
    this.addEventListener('open', this.handleOpen);
    this.addEventListener('close', this.handleClose);
    this.addEventListener('error', this.handleError);
    return this.addEventListener('message', this.handleMessage);
  }

  reconnect() {
    var delay;
    console.log('reconnect');
    this.connect();
    delay = this.computeReconnectDelay();
    console.log(delay);
    return this.reconnectTimer = setTimeout(this.reconnect, delay);
  }

  computeReconnectDelay() {
    var count, decay, delay, interval, intervalMax;
    interval = this.reconnectInterval;
    intervalMax = this.reconnectIntervalMax;
    decay = this.reconnectDecay;
    count = this.reconnectCount++;
    delay = interval * Math.pow(decay, count);
    if (delay > intervalMax) {
      delay = intervalMax;
    }
    return delay;
  }

  handleOpen() {
    var callback, i, len, ref, results;
    clearTimeout(this.reconnectTimer);
    this.reconnectTimer = null;
    this.reconnectCount = 0;
    this.isOpen = true;
    console.log('open');
    if (this.first) {
      this.first = false;
      this.sendFirst();
    }
    ref = this.openCallbacks;
    results = [];
    for (i = 0, len = ref.length; i < len; i++) {
      callback = ref[i];
      results.push(callback());
    }
    return results;
  }

  handleClose() {
    var callback, i, len, ref, results;
    this.isOpen = false;
    console.log('close');
    if (!this.reconnectTimer) {
      this.reconnect();
    }
    ref = this.closeCallbacks;
    results = [];
    for (i = 0, len = ref.length; i < len; i++) {
      callback = ref[i];
      results.push(callback());
    }
    return results;
  }

  handleError() {
    var callback, i, len, ref, results;
    this.isOpen = false;
    console.log('error');
    ref = this.errorCallbacks;
    results = [];
    for (i = 0, len = ref.length; i < len; i++) {
      callback = ref[i];
      results.push(callback());
    }
    return results;
  }

  handleMessage(message) {
    var callback, i, len, ref, results;
    message = message.data;
    ref = this.messageCallbacks;
    results = [];
    for (i = 0, len = ref.length; i < len; i++) {
      callback = ref[i];
      results.push(callback(message));
    }
    return results;
  }

  sendFirst() {
    var i, len, message, ref;
    ref = this.firstMessages;
    for (i = 0, len = ref.length; i < len; i++) {
      message = ref[i];
      this.send(message);
    }
    return this.firstMessages = [];
  }

  send(message) {
    if (this.first) {
      return this.firstMessages.push(message);
    } else if (this.isOpen) {
      return this.ws.send(message);
    } else {
      return this.readyMessages.push(message);
    }
  }

  on(event, callback) {
    return this[event + 'Callbacks'].push(callback);
  }

  addEventListener(event, callback) {
    if (this.ws.addEventListener) {
      return this.ws.addEventListener(event, callback);
    } else {
      return this.ws.on(event, callback);
    }
  }

};


/***/ }),
/* 6 */
/***/ (function(module, exports) {

module.exports = __WEBPACK_EXTERNAL_MODULE_6__;

/***/ }),
/* 7 */
/***/ (function(module, exports, __webpack_require__) {

var PostOffice, SaiJSON, uuidv4;

uuidv4 = __webpack_require__(0);

SaiJSON = __webpack_require__(11);

module.exports = PostOffice = class PostOffice {
  constructor(socket, adapter) {
    this.send = this.send.bind(this);
    this.seal = this.seal.bind(this);
    this.receive = this.receive.bind(this);
    this.unseal = this.unseal.bind(this);
    this.socket = socket;
    this.saiJSON = new SaiJSON(adapter);
    this.dict = {};
    this.socket.on('message', this.receive);
  }

  send(packet, callback) {
    return this.saiJSON.encode(packet, () => {
      var message, stamp;
      ({stamp, message} = this.seal(packet));
      this.dict[stamp] = callback;
      return this.socket.send(message);
    });
  }

  seal(packet, callback) {
    var message, stamp;
    stamp = uuidv4();
    message = {stamp, packet};
    message = JSON.stringify(message);
    return {stamp, message};
  }

  receive(message) {
    var callback, packet, stamp;
    ({stamp, packet} = this.unseal(message));
    callback = this.dict[stamp];
    if (callback) {
      delete this.dict[stamp];
      return this.saiJSON.decode(packet, () => {
        return callback(packet);
      });
    }
  }

  unseal(message) {
    var packet, stamp;
    message = JSON.parse(message);
    ({stamp, packet} = message);
    return {stamp, packet};
  }

};


/***/ }),
/* 8 */
/***/ (function(module, exports, __webpack_require__) {

/* WEBPACK VAR INJECTION */(function(global) {// Unique ID creation requires a high quality random # generator.  In the
// browser this is a little complicated due to unknown quality of Math.random()
// and inconsistent support for the `crypto` API.  We do the best we can via
// feature-detection
var rng;

var crypto = global.crypto || global.msCrypto; // for IE 11
if (crypto && crypto.getRandomValues) {
  // WHATWG crypto RNG - http://wiki.whatwg.org/wiki/Crypto
  var rnds8 = new Uint8Array(16); // eslint-disable-line no-undef
  rng = function whatwgRNG() {
    crypto.getRandomValues(rnds8);
    return rnds8;
  };
}

if (!rng) {
  // Math.random()-based (RNG)
  //
  // If all else fails, use Math.random().  It's fast, but is of unspecified
  // quality.
  var rnds = new Array(16);
  rng = function() {
    for (var i = 0, r; i < 16; i++) {
      if ((i & 0x03) === 0) r = Math.random() * 0x100000000;
      rnds[i] = r >>> ((i & 0x03) << 3) & 0xff;
    }

    return rnds;
  };
}

module.exports = rng;

/* WEBPACK VAR INJECTION */}.call(exports, __webpack_require__(9)))

/***/ }),
/* 9 */
/***/ (function(module, exports) {

var g;

// This works in non-strict mode
g = (function() {
	return this;
})();

try {
	// This works if eval is allowed (see CSP)
	g = g || Function("return this")() || (1,eval)("this");
} catch(e) {
	// This works if the window reference is available
	if(typeof window === "object")
		g = window;
}

// g can still be undefined, but nothing to do about it...
// We return undefined, instead of nothing here, so it's
// easier to handle this case. if(!global) { ...}

module.exports = g;


/***/ }),
/* 10 */
/***/ (function(module, exports) {

/**
 * Convert array of 16 byte values to UUID string format of the form:
 * XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX
 */
var byteToHex = [];
for (var i = 0; i < 256; ++i) {
  byteToHex[i] = (i + 0x100).toString(16).substr(1);
}

function bytesToUuid(buf, offset) {
  var i = offset || 0;
  var bth = byteToHex;
  return bth[buf[i++]] + bth[buf[i++]] +
          bth[buf[i++]] + bth[buf[i++]] + '-' +
          bth[buf[i++]] + bth[buf[i++]] + '-' +
          bth[buf[i++]] + bth[buf[i++]] + '-' +
          bth[buf[i++]] + bth[buf[i++]] + '-' +
          bth[buf[i++]] + bth[buf[i++]] +
          bth[buf[i++]] + bth[buf[i++]] +
          bth[buf[i++]] + bth[buf[i++]];
}

module.exports = bytesToUuid;


/***/ }),
/* 11 */
/***/ (function(module, exports, __webpack_require__) {

var CodeTask, SaiJSON;

CodeTask = __webpack_require__(12);

module.exports = SaiJSON = class SaiJSON {
  constructor(adapter) {
    this.encode = this.encode.bind(this);
    this.decode = this.decode.bind(this);
    this.adapter = adapter;
  }

  encode(packet, onComplete) {
    return new CodeTask(this.adapter, packet, onComplete).encode();
  }

  decode(packet, onComplete) {
    return new CodeTask(this.adapter, packet, onComplete).decode();
  }

};


/***/ }),
/* 12 */
/***/ (function(module, exports, __webpack_require__) {

var CodeTask, isPlainObject;

isPlainObject = __webpack_require__(13);

module.exports = CodeTask = class CodeTask {
  constructor(adapter, packet, onComplete) {
    this.checkComplete = this.checkComplete.bind(this);
    this.encode = this.encode.bind(this);
    this.decode = this.decode.bind(this);
    this.encodeEach = this.encodeEach.bind(this);
    this.decodeEach = this.decodeEach.bind(this);
    this.encodeDate = this.encodeDate.bind(this);
    this.decodeDate = this.decodeDate.bind(this);
    /* @Public */
    // (深度优先)遍历一颗树的全部叶子节点
    // callback(叶子key, 叶子value, 父节点parent)
    //#
    this.traverse = this.traverse.bind(this);
    this.traverseEach = this.traverseEach.bind(this);
    this.isFile = adapter.isFile;
    this.encodeFile = adapter.encodeFile;
    this.decodeFile = adapter.decodeFile;
    this.packet = packet;
    this.onComplete = onComplete;
    this.isComplete = false;
    this.files = [];
  }

  checkComplete() {
    if (this.isComplete === false) {
      if (this.files.length === 0) {
        this.isComplete = true;
        return this.onComplete();
      }
    }
  }

  encode() {
    this.traverse(this.packet, this.encodeEach);
    return this.checkComplete();
  }

  decode() {
    this.traverse(this.packet, this.decodeEach);
    return this.checkComplete();
  }

  encodeEach(value, key, parent) {
    if (value instanceof Date) {
      return parent[key] = this.encodeDate(value);
    } else if (this.isFile(value)) {
      this.files.push(true);
      return this.encodeFile(value, (fileString) => {
        parent[key] = fileString;
        this.files.pop();
        return this.checkComplete();
      });
    }
  }

  decodeEach(value, key, parent) {
    var dateRegExp, fileRegExp;
    dateRegExp = /^\/Date\(\d+\)\/$/;
    fileRegExp = /^\/File\(.+\)\/$/;
    if (dateRegExp.test(value)) {
      return parent[key] = this.decodeDate(value);
    } else if (fileRegExp.test(value)) {
      this.files.push(true);
      return this.decodeFile(value, (decodeFile) => {
        parent[key] = decodeFile;
        this.files.pop();
        return this.checkComplete();
      });
    }
  }

  encodeDate(date) {
    var timeStamp;
    timeStamp = date.getTime();
    return `/Date(${timeStamp})/`;
  }

  decodeDate(dateString) {
    var timeStamp;
    timeStamp = dateString.slice(6, dateString.length - 2);
    timeStamp = parseInt(timeStamp);
    return new Date(timeStamp);
  }

  traverse(tree, callback) {
    return this.traverseEach(tree, null, null, callback);
  }

  traverseEach(node, key, parent, callback) {
    var child, i, j, len, results, results1;
    // 嵌套对象
    if (isPlainObject(node)) {
      results = [];
      for (key in node) {
        child = node[key];
        results.push(this.traverseEach(child, key, node, callback));
      }
      return results;
    // 数组
    } else if (Array.isArray(node)) {
      results1 = [];
      for (i = j = 0, len = node.length; j < len; i = ++j) {
        child = node[i];
        results1.push(this.traverseEach(child, i, node, callback));
      }
      return results1;
    } else {
      // 叶子节点
      return callback(node, key, parent);
    }
  }

};


/***/ }),
/* 13 */
/***/ (function(module, exports) {

/**
 * lodash (Custom Build) <https://lodash.com/>
 * Build: `lodash modularize exports="npm" -o ./`
 * Copyright jQuery Foundation and other contributors <https://jquery.org/>
 * Released under MIT license <https://lodash.com/license>
 * Based on Underscore.js 1.8.3 <http://underscorejs.org/LICENSE>
 * Copyright Jeremy Ashkenas, DocumentCloud and Investigative Reporters & Editors
 */

/** `Object#toString` result references. */
var objectTag = '[object Object]';

/**
 * Checks if `value` is a host object in IE < 9.
 *
 * @private
 * @param {*} value The value to check.
 * @returns {boolean} Returns `true` if `value` is a host object, else `false`.
 */
function isHostObject(value) {
  // Many host objects are `Object` objects that can coerce to strings
  // despite having improperly defined `toString` methods.
  var result = false;
  if (value != null && typeof value.toString != 'function') {
    try {
      result = !!(value + '');
    } catch (e) {}
  }
  return result;
}

/**
 * Creates a unary function that invokes `func` with its argument transformed.
 *
 * @private
 * @param {Function} func The function to wrap.
 * @param {Function} transform The argument transform.
 * @returns {Function} Returns the new function.
 */
function overArg(func, transform) {
  return function(arg) {
    return func(transform(arg));
  };
}

/** Used for built-in method references. */
var funcProto = Function.prototype,
    objectProto = Object.prototype;

/** Used to resolve the decompiled source of functions. */
var funcToString = funcProto.toString;

/** Used to check objects for own properties. */
var hasOwnProperty = objectProto.hasOwnProperty;

/** Used to infer the `Object` constructor. */
var objectCtorString = funcToString.call(Object);

/**
 * Used to resolve the
 * [`toStringTag`](http://ecma-international.org/ecma-262/7.0/#sec-object.prototype.tostring)
 * of values.
 */
var objectToString = objectProto.toString;

/** Built-in value references. */
var getPrototype = overArg(Object.getPrototypeOf, Object);

/**
 * Checks if `value` is object-like. A value is object-like if it's not `null`
 * and has a `typeof` result of "object".
 *
 * @static
 * @memberOf _
 * @since 4.0.0
 * @category Lang
 * @param {*} value The value to check.
 * @returns {boolean} Returns `true` if `value` is object-like, else `false`.
 * @example
 *
 * _.isObjectLike({});
 * // => true
 *
 * _.isObjectLike([1, 2, 3]);
 * // => true
 *
 * _.isObjectLike(_.noop);
 * // => false
 *
 * _.isObjectLike(null);
 * // => false
 */
function isObjectLike(value) {
  return !!value && typeof value == 'object';
}

/**
 * Checks if `value` is a plain object, that is, an object created by the
 * `Object` constructor or one with a `[[Prototype]]` of `null`.
 *
 * @static
 * @memberOf _
 * @since 0.8.0
 * @category Lang
 * @param {*} value The value to check.
 * @returns {boolean} Returns `true` if `value` is a plain object, else `false`.
 * @example
 *
 * function Foo() {
 *   this.a = 1;
 * }
 *
 * _.isPlainObject(new Foo);
 * // => false
 *
 * _.isPlainObject([1, 2, 3]);
 * // => false
 *
 * _.isPlainObject({ 'x': 0, 'y': 0 });
 * // => true
 *
 * _.isPlainObject(Object.create(null));
 * // => true
 */
function isPlainObject(value) {
  if (!isObjectLike(value) ||
      objectToString.call(value) != objectTag || isHostObject(value)) {
    return false;
  }
  var proto = getPrototype(value);
  if (proto === null) {
    return true;
  }
  var Ctor = hasOwnProperty.call(proto, 'constructor') && proto.constructor;
  return (typeof Ctor == 'function' &&
    Ctor instanceof Ctor && funcToString.call(Ctor) == objectCtorString);
}

module.exports = isPlainObject;


/***/ }),
/* 14 */
/***/ (function(module, exports, __webpack_require__) {

var RPC, Task, TaskGroup;

Task = __webpack_require__(15);

TaskGroup = __webpack_require__(16);

module.exports = RPC = class RPC {
  constructor(client) {
    this.call = this.call.bind(this);
    this.callBatch = this.callBatch.bind(this);
    this.callSeq = this.callSeq.bind(this);
    this.callParal = this.callParal.bind(this);
    this.task = this.task.bind(this);
    this.send = this.send.bind(this);
    this.client = client;
  }

  call(method, params) {
    var task;
    task = new Task(method, params);
    this.send(task);
    return task;
  }

  callBatch(tasks) {
    var taskGroup;
    taskGroup = new TaskGroup(tasks);
    this.send(taskGroup);
    return taskGroup;
  }

  callSeq(tasks) {
    var i, j, last, len, next, task, taskGroup;
    taskGroup = new TaskGroup(tasks);
    last = tasks.length - 1;
    for (i = j = 0, len = tasks.length; j < len; i = ++j) {
      task = tasks[i];
      if (i < last) {
        next = tasks[i + 1];
        ((next) => {
          return task.always(() => {
            return this.send(next);
          });
        })(next);
      } else {
        task.always(() => {
          return taskGroup.complete();
        });
      }
    }
    this.send(tasks[0]);
    return taskGroup;
  }

  callParal(tasks) {
    var count, j, len, task, taskGroup, total;
    taskGroup = new TaskGroup(tasks);
    total = tasks.length;
    count = 0;
    for (j = 0, len = tasks.length; j < len; j++) {
      task = tasks[j];
      task.always(() => {
        count += 1;
        if (count === total) {
          return taskGroup.complete();
        }
      });
      this.send(task);
    }
    return taskGroup;
  }

  task(method, params) {
    return new Task(method, params);
  }

  send(taskOrTaskGroup) {
    return setTimeout(() => {
      return this.client.send(taskOrTaskGroup.getPacket(), taskOrTaskGroup.complete);
    });
  }

};


/***/ }),
/* 15 */
/***/ (function(module, exports, __webpack_require__) {

var Task, uuidv4;

uuidv4 = __webpack_require__(0);

module.exports = Task = class Task {
  constructor(method, params) {
    this.done = this.done.bind(this);
    this.fail = this.fail.bind(this);
    this.always = this.always.bind(this);
    this.getPacket = this.getPacket.bind(this);
    this.complete = this.complete.bind(this);
    this.method = method;
    this.params = params;
    this.id = uuidv4();
    this.dones = [];
    this.fails = [];
    this.result = null;
    this.error = null;
  }

  done(callback) {
    this.dones.push(callback);
    return this;
  }

  fail(callback) {
    this.fails.push(callback);
    return this;
  }

  always(callback) {
    this.dones.push(callback);
    this.fails.push(callback);
    return this;
  }

  getPacket() {
    return {
      jsonrpc: '2.0',
      method: this.method,
      params: this.params,
      id: this.id
    };
  }

  complete({result, error}) {
    var done, fail, i, j, len, len1, ref, ref1, results, results1;
    if (error) {
      this.error = error;
      ref = this.fails;
      results = [];
      for (i = 0, len = ref.length; i < len; i++) {
        fail = ref[i];
        results.push(fail(error, this));
      }
      return results;
    } else {
      this.result = result;
      ref1 = this.dones;
      results1 = [];
      for (j = 0, len1 = ref1.length; j < len1; j++) {
        done = ref1[j];
        results1.push(done(result, this));
      }
      return results1;
    }
  }

};


/***/ }),
/* 16 */
/***/ (function(module, exports) {

var TaskGroup;

module.exports = TaskGroup = class TaskGroup {
  constructor(tasks) {
    this.doneEach = this.doneEach.bind(this);
    this.failEach = this.failEach.bind(this);
    this.done = this.done.bind(this);
    this.getPacket = this.getPacket.bind(this);
    this.receive = this.receive.bind(this);
    this.complete = this.complete.bind(this);
    this.tasks = tasks;
    this.dones = [];
  }

  doneEach(callback) {
    var j, len, ref, task;
    ref = this.tasks;
    for (j = 0, len = ref.length; j < len; j++) {
      task = ref[j];
      task.done(callback);
    }
    return this;
  }

  failEach(callback) {
    var j, len, ref, task;
    ref = this.tasks;
    for (j = 0, len = ref.length; j < len; j++) {
      task = ref[j];
      task.fail(callback);
    }
    return this;
  }

  done(callback) {
    this.dones.push(callback);
    return this;
  }

  getPacket() {
    return this.tasks.map((task) => {
      return task.getPacket();
    });
  }

  receive(response) {
    var i, j, len, packages, ref, task;
    packages = response.data;
    helper.decodeBody(packages);
    ref = this.tasks;
    // @TODO 支持通知后需要比对id来对应触发
    for (i = j = 0, len = ref.length; j < len; i = ++j) {
      task = ref[i];
      task.complete(packages[i]);
    }
    return this.complete();
  }

  complete(packet) {
    var done, i, j, k, len, len1, ref, ref1, results, task;
    ref = this.tasks;
    // @TODO 支持通知后需要比对id来对应触发
    for (i = j = 0, len = ref.length; j < len; i = ++j) {
      task = ref[i];
      task.complete(packet[i]);
    }
    ref1 = this.dones;
    results = [];
    for (k = 0, len1 = ref1.length; k < len1; k++) {
      done = ref1[k];
      results.push(done());
    }
    return results;
  }

};


/***/ })
/******/ ]);
});