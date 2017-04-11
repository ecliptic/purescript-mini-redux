const ReactRedux = require('react-redux')
const Redux = require('redux')

exports.combineReducers = Redux.combineReducers
exports.applyMiddleware = Redux.applyMiddleware
exports.reduxCreateStore = Redux.createStore
exports.provider = ReactRedux.Provider

exports.applyReducer = function (reducer) {
  return function (action) {
    return function (state) {
      return reducer(action)(state)
    }
  }
}

exports.connect = function (mapStateToProps) {
  return function (mapDispatchToProps) {
    return ReactRedux.connect(mapStateToProps, mapDispatchToProps)
  }
}

exports.typeToString = function (action) {
  if (typeof action === 'string') return action

  const name = action.constructor.name

  const values = Object.keys(action).map(function (prop) {
    if (prop.startsWith('value')) {
      const value = action[prop]

      if (typeof value === 'object') {
        return '[object]'
      }

      return JSON.stringify(value)
    }
  })

  return name + ' ' + values.join(' ')
}
