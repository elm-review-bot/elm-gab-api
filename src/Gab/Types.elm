----------------------------------------------------------------------
--
-- Types.elm
-- Shared type definitions.
-- Copyright (c) 2017 Bill St. Clair <billstclair@gmail.com>
-- Some rights reserved.
-- Distributed under the MIT License
-- See LICENSE.txt
--
----------------------------------------------------------------------


module Gab.Types exposing
    ( RequestParts, HttpBody(..)
    , PostResult, PostResultState(..)
    , User, UserList
    , ActivityLog, ActivityLogList
    , Post, PostList
    , Embed, CategoryDetails, Topic, RelatedPosts(..)
    , Attachment(..), UrlRecord, MediaRecord, UnknownAttachmentRecord
    )

{-| Shared Types for the Gab API.


# Http Requests

@docs RequestParts, HttpBody


# Http Results

@docs PostResult, PostResultState


# Users

@docs User, UserList


# Activity Logs

@docs ActivityLog, ActivityLogList


# Posts

@docs Post, PostList
@docs Embed, CategoryDetails, Topic, RelatedPosts


# Attachments

@docs Attachment, UrlRecord, MediaRecord, UnknownAttachmentRecord

-}

import Http
import Json.Encode exposing (Value)


{-| A custom type for request bodies.
-}
type HttpBody
    = EmptyBody
    | JsonBody Value
    | StringBody String String
    | OtherBody Http.Body


{-| Names the argument to `Http.request`.
-}
type alias RequestParts a =
    { method : String
    , headers : List Http.Header
    , url : String
    , body : HttpBody
    , expect : Http.Expect a
    , timeout : Maybe Float
    , withCredentials : Bool
    }


{-| Details of a Gab user.
-}
type alias User =
    { id : Int
    , name : String
    , username : String
    , picture_url : String
    , verified : Bool
    , is_investor : Bool --not really required
    , is_pro : Bool
    , is_private : Bool
    , is_premium : Bool

    -- optional fields, according to the JSON spec.
    , created_at_month_label : Maybe String
    , follower_count : Maybe Int
    , following_count : Maybe Int
    , post_count : Maybe Int
    , picture_url_full : Maybe String
    , following : Bool
    , followed : Bool
    , is_donor : Bool
    , is_tippable : Bool
    , premium_price : Maybe Float
    , is_accessible : Bool
    , follow_pending : Bool
    , unread_notification_count : Maybe Int
    , stream : Bool
    , bio : Maybe String
    , cover_url : Maybe String
    , show_replies : Bool
    , sound_alerts : Bool
    , email : Maybe String
    , notify_followers : Bool
    , notify_mentions : Bool
    , notify_likes : Bool
    , notify_reposts : Bool
    , score : Maybe Int
    , broadcast_channel : Maybe String
    , exclusive_features : Bool
    , social_facebook : Bool
    , social_twitter : Bool
    , is_pro_overdue : Bool
    , pro_expires_at : Maybe String
    , has_chat : Bool
    , has_chat_unread : Bool
    , germany_law : Bool
    , language : Maybe String
    , pinned_post_id : Maybe String
    , nsfw_filter : Bool
    , hide_premium_content : Bool
    , video_count : Maybe Int
    , can_downvote : Bool
    }


{-| A list of `User` records.
-}
type alias UserList =
    { data : List User
    , no_more : Bool
    }


{-| Part of a `Post`.
-}
type RelatedPosts
    = RelatedPosts
        { parent : Maybe Post
        , replies : PostList
        }


{-| One post returned from one of the feed reader functions.
-}
type alias Post =
    { id : Int
    , created_at : String
    , revised_at : Maybe String
    , edited : Bool
    , body : String
    , only_emoji : Bool
    , liked : Bool
    , disliked : Bool
    , bookmarked : Bool
    , repost : Bool
    , reported : Bool
    , score : Int
    , like_count : Int
    , dislike_count : Int
    , reply_count : Int
    , repost_count : Int
    , is_quote : Bool
    , is_reply : Bool
    , is_replies_disabled : Bool
    , embed : Maybe Embed
    , attachment : Attachment
    , category : Maybe Int
    , category_details : Maybe CategoryDetails
    , language : Maybe String
    , nsfw : Bool
    , is_premium : Bool
    , is_locked : Bool
    , user : User
    , topic : Maybe Topic
    , related : RelatedPosts
    }


{-| Details of a `UrlAttachment`.
-}
type alias UrlRecord =
    { image : String
    , title : Maybe String
    , description : Maybe String
    , url : String
    , source : String
    }


{-| Details for a `MediaAttachment`.
-}
type alias MediaRecord =
    { id : String
    , url_thumbnail : String
    , url_full : String
    , width : Int
    , height : Int
    }


{-| Data about an `UnknownAttachment`.
-}
type alias UnknownAttachmentRecord =
    { type_ : String
    , value : Value
    }


{-| Attachment to a `Post`.
-}
type Attachment
    = NoAttachment --type == null
      --type == "url"
    | UrlAttachment UrlRecord
      --type == "media"
    | MediaAttachment (List MediaRecord)
      -- type == "youtube"
    | YoutubeAttachment String
      -- type == "giphy"
    | GiphyAttachment String
      -- There may be types I haven't seen yet.
    | UnknownAttachment UnknownAttachmentRecord


{-| Category details in a `Post`.
-}
type alias CategoryDetails =
    { title : String
    , slug : String
    , value : Int
    , emoji : String
    }


{-| Embed in a `Post`.
-}
type alias Embed =
    { html : String
    , iframe : Bool
    }


{-| The topic of a `Post`.
-}
type alias Topic =
    { id : String
    , created_at : String
    , is_featured : Bool
    , title : String
    , category : Int
    , user : Maybe User
    }


{-| A list of `Post` instances.
-}
type alias PostList =
    List Post


{-| One element of the list returned from the feed reading functions.
-}
type alias ActivityLog =
    { id : String
    , published_at : String
    , type_ : String
    , actuser : User
    , post : Post
    }


{-| A list of `ActivityLog` instances.
-}
type alias ActivityLogList =
    { data : List ActivityLog
    , no_more : Bool
    }


{-| The value of `PostResult.state` for a successful operation.
-}
type PostResultState
    = UnknownState
    | SuccessState --"success"


{-| Returned from the Post and Delete actions
-}
type alias PostResult =
    { state : PostResultState
    , message : String
    }
