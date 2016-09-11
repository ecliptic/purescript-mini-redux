# purescript-mini-redux

[![Latest release](https://img.shields.io/npm/v/purescript-mini-redux.svg)](https://github.com/ecliptic/purescript-mini-redux/releases)
[![Latest release](https://img.shields.io/bower/v/purescript-mini-redux.svg)](https://github.com/ecliptic/purescript-mini-redux/releases)
[![redux channel on discord](https://img.shields.io/badge/discord-%23redux%20%40%20reactiflux-61dafb.svg?style=flat-square)](https://discord.gg/2PCKqHc)
[![Build Status](https://travis-ci.org/ecliptic/purescript-mini-redux.svg?branch=master)](https://travis-ci.org/ecliptic/purescript-mini-redux)

An idiomatic PureScript mini-interface to [Redux](http://redux.js.org/).

## Why?

Because I want to work with Redux in an idiomatic way inspired by `purescript-redux-utils`, but in a more lightweight and less intrusive fashion. Store creation is still handled by your imperative code, but reducers and actions are defined in your PureScript modules, and thus they are strictly typed and purely functional.

## Usage

Install with bower:

    $ bower install --save purescript-mini-redux

Define your root reducer and initial state with PureScript (only for this example - you can actually compose PureScript and plain JavaScript reducers any way you like):

```purescript
module MyApp.State.Store (rootReducer, initialState) where

import Control.Monad.Eff (Eff)
import MyApp.State.MyReducer (State, initialState, reducer) as MyReducer
import Redux.Mini (Store, STORE, ReduxReducer, combineReducers)

rootReducer :: forall action state. ReduxReducer action state
rootReducer = combineReducers { myReducer: MyReducer.reducer }

initialState :: { myReducer :: MyReducer.State }
initialState = { myReducer: MyReducer.initialState }
```

Define your child reducers in PureScript as well:

```purescript
module MyApp.State.MyReducer
  ( Action(..)
  , State(State)
  , setMyValue
  , initialState
  , reducer
  ) where

import Prelude
import Redux.Mini (Action) as Redux
import Redux.Mini (Reducer, ReduxReducer, createAction, createReducer)

type State = { myValue :: String }

-- Actions ---------------------------------------------------------------------

data Action = Set String
  | Else -- Represents external actions

setMyValue :: String -> Redux.Action Action
setMyValue value = createAction $ Set value

-- Reducer ---------------------------------------------------------------------

initialState :: State
initialState = { myValue: "" }

myReducer :: Reducer Action State
myReducer (Set value) state = state { myValue = value }
myReducer _ state = state

reducer :: ReduxReducer Action State
reducer = createReducer myReducer initialState
```

Then create your store with JavaScript:

```javascript
/* MyApp/State/Create.js */
import {rootReducer} from 'MyApp/State/Store.purs'
import * as Redux from 'redux'

function devToolsEnhancer () {
  if (typeof window === 'object' && typeof window.devToolsExtension !== 'undefined') {
    return window.devToolsExtension()
  }
  return id => id
}

export function createStore (initialState) {
  const enhancers = [devToolsEnhancer()]

  const store = Redux.createStore(
    rootReducer,
    initialState,
    Redux.compose(...enhancers)
  )

  return store
}
```

Now, you can call your createStore function and pass it an optional initialState value:

```javascript
import {createStore} from 'MyApp/State/Create'
import {Provider} from 'react-redux'

const store = createStore()

const element = (
  <Provider store={store}>
    <div>My awesome component is awesome!</div>
  </Provider>
)
```

## API Documentation

Coming soon...

## License

MIT
