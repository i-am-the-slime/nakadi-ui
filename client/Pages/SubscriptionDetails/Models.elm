module Pages.SubscriptionDetails.Models exposing (..)

import Stores.SubscriptionStats
import Stores.SubscriptionCursors
import Helpers.String exposing (justOrCrash)
import Dict exposing (get)
import Constants exposing (emptyString)
import Helpers.Store exposing (Status(Unknown), ErrorMessage)
import Helpers.String exposing (justOrCrash, getMaybeBool, queryMaybeToUrl)


initialModel : Model
initialModel =
    { id = emptyString
    , statsStore = Stores.SubscriptionStats.initialModel
    , cursorsStore = Stores.SubscriptionCursors.initialModel
    , tab = StatsTab
    , editOffsetInput =
        { editPartition = Nothing
        , editPartitionValue = emptyString
        , status = Unknown
        , error = Nothing
        }
    , deletePopup =
        { isOpen = False
        , deleteCheckbox = False
        , status = Unknown
        , error = Nothing
        }
    }


type alias Model =
    { id : String
    , statsStore : Stores.SubscriptionStats.Model
    , cursorsStore : Stores.SubscriptionCursors.Model
    , tab : Tabs
    , editOffsetInput :
        { editPartition : Maybe String
        , editPartitionValue : String
        , status : Status
        , error : Maybe ErrorMessage
        }
    , deletePopup :
        { isOpen : Bool
        , deleteCheckbox : Bool
        , status : Status
        , error : Maybe ErrorMessage
        }
    }


type Tabs
    = StatsTab
    | AuthTab


type alias UrlParams =
    { id : String
    }


dictToParams : Dict.Dict String String -> UrlParams
dictToParams dict =
    { id =
        get Constants.id dict |> justOrCrash "Incorrect url template. Missing /:id/"
    }


type alias UrlQuery =
    { tab : Maybe Tabs
    }


emptyQuery : UrlQuery
emptyQuery =
    dictToQuery Dict.empty


queryToUrl : UrlQuery -> String
queryToUrl query =
    queryMaybeToUrl <|
        Dict.fromList
            [ ( "tab", query.tab |> Maybe.map toString )
            ]


dictToQuery : Dict.Dict String String -> UrlQuery
dictToQuery dict =
    { tab =
        get "tab" dict |> Maybe.andThen stringToTabs
    }


stringToTabs : String -> Maybe Tabs
stringToTabs str =
    case str of
        "StatsTab" ->
            Just StatsTab

        "AuthTab" ->
            Just AuthTab

        _ ->
            Nothing
