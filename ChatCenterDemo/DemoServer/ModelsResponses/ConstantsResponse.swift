//
// ConstantsResponse.swift
// ChatCenterDemo
//
// Copyright © 2025 edna. All rights reserved.
//

import Foundation

// swiftlint:disable all

enum ConstantsResponse {
    case testResponse
    case initChat
    case schedule
    case attachments

    // MARK: Internal

    func getResponse(correlationId: String = "", idMessage _: String = "") -> String {
        switch self {
        case .testResponse:
            """
            {
            "data" : {
            "deviceAddress" : "apns_id1_fjb4va4kmikrpaydlqqql203o4ht7h82"
            },
            "action" : "registerDevice",
            "correlationId" : "\(correlationId)"
            }
            """
        case .initChat:
            """
            {
            "data" : {
            "messageId" : "f90e574a-d128-4d99-80db-654068809105",
            "status" : "sent",
            "sentAt" : "2023-07-18T06:12:14.724Z"
            },
            "action" : "sendMessage",
            "correlationId" : "\(correlationId)"
            }
            """
        case .schedule:
            """
                    {
            "action" : "getMessages",
            "data" : {
            "messages" : [
            {
            "messageId" : "46b17bc7-029d-4fed-9a9f-48cb8b9ad250",
            "sentAt" : "2023-07-20T04:00:04.670Z",
            "content" : {
            "externalClientId" : "id1",
            "content" : {
            "active" : true,
            "isVisibleOutOfHours" : true,
            "id" : 3,
            "notification" : "Пора отдохнуть",
            "serverTime" : "2023-07-20T04:00:04.643Z",
            "intervals" : [
            {
            "startTime" : 0,
            "id" : 171,
            "endTime" : 86399,
            "weekDay" : 1
            },
            {
            "startTime" : 0,
            "id" : 16,
            "endTime" : 86399,
            "weekDay" : 2
            },
            {
            "startTime" : 0,
            "id" : 173,
            "endTime" : 86399,
            "weekDay" : 3
            },
            {
            "startTime" : 0,
            "id" : 112,
            "endTime" : 86399,
            "weekDay" : 4
            },
            {
            "startTime" : 0,
            "id" : 153,
            "endTime" : 86399,
            "weekDay" : 5
            },
            {
            "startTime" : 0,
            "id" : 20,
            "endTime" : 86399,
            "weekDay" : 6
            },
            {
            "startTime" : 0,
            "id" : 21,
            "endTime" : 86399,
            "weekDay" : 7
            }
            ],
            "sendDuringInactive" : true
            },
            "aps/sound" : "default",
            "massPushMessage" : false,
            "origin" : "threads",
            "clientId" : "id1",
            "text" : "{\\"id\\":3,\\"active\\":true,\\"notification\\":\\"Пора отдохнуть\\",\\"intervals\\":[{\\"id\\":171,\\"weekDay\\":1,\\"startTime\\":0,\\"endTime\\":86399},{\\"id\\":16,\\"weekDay\\":2,\\"startTime\\":0,\\"endTime\\":86399},{\\"id\\":173,\\"weekDay\\":3,\\"startTime\\":0,\\"endTime\\":86399},{\\"id\\":112,\\"weekDay\\":4,\\"startTime\\":0,\\"endTime\\":86399},{\\"id\\":153,\\"weekDay\\":5,\\"startTime\\":0,\\"endTime\\":86399},{\\"id\\":20,\\"weekDay\\":6,\\"startTime\\":0,\\"endTime\\":86399},{\\"id\\":21,\\"weekDay\\":7,\\"startTime\\":0,\\"endTime\\":86399}],\\"sendDuringInactive\\":true,\\"isVisibleOutOfHours\\":true,\\"serverTime\\":\\"2023-07-20T04:00:04.643Z\\"}",
            "authorized" : true,
            "type" : "SCHEDULE",
            "providerIds" : [

            ]
            },
            "notification" : null,
            "important" : false,
            "attributes" : "{\\"clientId\\":\\"id1\\",\\"aps/content-available\\":\\"1\\",\\"origin\\":\\"threads\\"}",
            "messageType" : "NORMAL"
            }
            ]
            }
            }
            """
        case .attachments:
            """
            {
              "action" : "getMessages",
              "data" : {
                "messages" : [
                  {
                    "messageId" : "adf04adc-d579-4147-b2cd-17ed4bb93537",
                    "sentAt" : "2023-07-20T04:00:04.671Z",
                    "content" : {
                      "externalClientId" : "id1",
                      "content" : {
                        "maxSize" : 30,
                        "fileExtensions" : [
                          "jpeg",
                          "jpg",
                          "png",
                          "pdf",
                          "doc",
                          "docx",
                          "rtf",
                          "bmp",
                          "tar.gz",
                          "tar",
                          "gz",
                          "tgz",
                          "mp4",
                          "webp",
                          "webm",
                          "tgs",
                          "ogg",
                          "txt",
                          "xls",
                          "oga",
                          "mp3"
                        ]
                      },
                      "aps/sound" : "default",
                      "massPushMessage" : false,
                      "origin" : "threads",
                      "clientId" : "id1",
                      "authorized" : true,
                      "type" : "ATTACHMENT_SETTINGS",
                      "providerIds" : []
                    },
                    "notification" : null,
                    "important" : false,
                    "attributes" : "{\\"clientId\\":\\"id1\\",\\"aps/sound\\":\\"default\\",\\"origin\\":\\"threads\\"}",
                    "messageType" : "NORMAL"
                  }
                ]
              }
            }
            """
        }
    }
}

// swiftlint:enable all
