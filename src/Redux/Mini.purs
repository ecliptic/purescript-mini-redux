module Redux.Mini
  ( Action
  , CreateStore
  , Dispatch
  , Middleware
  , Reducer
  , ReduxReducer
  , Store
  , STORE
  , applyMiddleware
  , applyReducer
  , combineReducers
  , connect
  , createAction
  , createReducer
  , createStore
  , provider
  , reduxCreateStore
  ) where

import Prelude
import Control.Monad.Eff (kind Effect, Eff)
import Data.Function.Uncurried (Fn2, Fn3, mkFn2, runFn3)
import Data.Maybe (Maybe(Just))
import Data.Nullable (toMaybe, Nullable)
import React (ReactClass)

foreign import data Store :: Type
foreign import data STORE :: Effect

-- Types
-- -----

-- | An Action has a "type" for Redux compatibility, and a "pureType" to hold
-- | the actual underlying algebraic data type.
newtype Action action = Action { type :: String, pureType :: action }

-- | A function that dispatches actions
type Dispatch action eff = Action action  -- ^ The action to be dispatched
  -> Eff (store :: STORE | eff) (Action action)  -- ^ The resulting effect

-- | A simple PureScript reducer
type Reducer action state = action -> state -> state

-- | A reducer wrapped for use with Redux
newtype ReduxReducer action state =
  ReduxReducer (Fn2 (Nullable state) (Action action) state)

type CreateStore action state enhancer =
  Fn3  -- ^ An uncurried function
    (ReduxReducer action state)  -- ^ The root reducer
    state  -- ^ The initial state
    (Array enhancer)  -- ^ An array of store enhancers
    Store  -- ^ The resulting store

type Middleware eff action =
  Fn3  -- ^ An uncurried function
    Store  -- ^ The current store instance
    (Dispatch action eff)  -- ^ The dispatch function
    (Action action)  -- ^ The action currently being dispatched
    (Eff (store :: STORE | eff) (Action action))  -- ^ The resulting effect

-- Interfaces
-- ----------

-- | Easily combine reducers using the underlying Redux utility
foreign import combineReducers :: forall reducers action state.
  Record reducers -> ReduxReducer action state

-- | The <Provider/> component from react-redux
foreign import provider :: ReactClass { store :: Store }

-- | The connect wrapper from react-redux.
-- | *NOTE*: The mergeProps and options arguments are not yet supported.
foreign import connect :: forall actions state ownerProps props.
  (state -> props)  -- ^ The mapStateToProps function
  -> actions  -- ^ The mapActionsToProps object
  -> ReactClass props  -- ^ The component being wrapped
  -> ReactClass ownerProps  -- ^ The resulting higher-order component

-- | The original Redux createStore function
foreign import reduxCreateStore :: forall action state enhancer.
  CreateStore action state enhancer

foreign import applyMiddleware :: forall eff action enhancer.
  Array (Middleware eff action) -> enhancer

-- Utilities
-- ---------

createStore :: forall action state enhancer.
  ReduxReducer action state  -- ^ The root reducer
  -> state  -- ^ The initial state
  -> Array enhancer  -- ^ An array of store enhancers
  -> Store  -- ^ The resulting store
createStore = runFn3 reduxCreateStore

-- | Construct a Redux reducer, which wraps the underlying action in an Action
-- | newtype that gives it a "type" property when used in JavaScript FFI
createReducer :: forall action state.
  Reducer action state -> state -> ReduxReducer action state
createReducer reducer initialState = ReduxReducer <<< mkFn2 $
  \state (Action action) ->
    case (toMaybe state) of
      (Just s) -> applyReducer reducer action.pureType s
      otherwise -> initialState

-- | Construct a pure Redux action
createAction :: forall action. action -> Action action
createAction action = Action
  { type: typeToString action, pureType: action }

-- | Apply the given action and current state to a PureScript reducer
foreign import applyReducer :: forall action state.
  Reducer action state -> action -> state -> state

-- | Transform the action's type to a string for Redux
foreign import typeToString :: forall action. action -> String
