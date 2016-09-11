## Module Redux.Mini

#### `Store`

``` purescript
data Store :: *
```

#### `STORE`

``` purescript
data STORE :: !
```

#### `Action`

``` purescript
newtype Action action
```

#### `Reducer`

``` purescript
type Reducer action state = action -> state -> state
```

The simple PureScript reducer

#### `ReduxReducer`

``` purescript
newtype ReduxReducer action state
```

A reducer wrapped for use with Redux

#### `applyReducer`

``` purescript
applyReducer :: forall action state. Reducer action state -> action -> state -> state
```

#### `createReducer`

``` purescript
createReducer :: forall action state. Reducer action state -> state -> ReduxReducer action state
```

Construct a Redux reducer, which wraps the underlying action in an Action
newtype that gives it a "type" property when used in JavaScript FFI

#### `createAction`

``` purescript
createAction :: forall action. action -> Action action
```

Construct a pure Redux action

#### `combineReducers`

``` purescript
combineReducers :: forall reducers action state. {  | reducers } -> ReduxReducer action state
```

Easily combine reducers using the underlying Redux utility

#### `provider`

``` purescript
provider :: ReactClass { store :: Store }
```

The <Provider/> component from react-redux

#### `connect`

``` purescript
connect :: forall state actions ownerProps props. (state -> props) -> actions -> ReactClass props -> ReactClass ownerProps
```

The connect wrapper from react-redux.
*NOTE*: The mergeProps and options arguments are not yet supported.


