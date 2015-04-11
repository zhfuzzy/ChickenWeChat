;; basic wechat server
(use spiffy intarweb uri-common srfi-13)
(use dissector)

(include "utils") (include "dispatcher")
(include "token-man") (include "validate") #;crypt
(include "message") (include "response-sync") (include "response-async")

(text-handler  (lambda (to from content)
                 (case (symbol<-string (string-downcase content))
                   [(|hello|)
                    (sync-response to from "Hello From Chicken!")]
                   [(|fox say| |fox|)
                    (begin1 (acknowledge-string) ; return ack("") for later async response
                            (async-response to from "bing bing")
                            (async-response to from "bing bing bing ~"))]
                   [else
                    (sync-response to from "Don't know what to say...")])))

(event-handler (lambda (to from event event-key)
                 (case (symbol<-string event-key)
                   [(|EVT_LIKE|)
                    (sync-response to from "You like it!")]
                   [(|EVT_UNLIKE|)
                    (sync-response to from "You don't like it...")]
                   [(|EVT_HELP|)
                    (sync-response to from "现在还没有设计命令\n想说什么就直接发过来~~暂不支持语音")]
                   [else
                    (sync-response to from "还不会处理这个按钮...")])))

(parameterize ((server-port 4000)
               (access-log  (current-output-port))
               (debug-log   (current-output-port)))
  (start-server))
