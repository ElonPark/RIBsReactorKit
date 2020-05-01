//
//  RandomUserFixture.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/04/26.
//  Copyright © 2020 Elon. All rights reserved.
//

import Foundation

// swiftlint:disable type_body_length
enum RandomUserFixture {
  static var data: Data {
    return """
    {
        "results": [{
                "gender": "male",
                "name": {
                    "title": "Monsieur",
                    "first": "Levin",
                    "last": "Lecomte"
                },
                "location": {
                    "street": {
                        "number": 8091,
                        "name": "Place Paul-Duquaire"
                    },
                    "city": "Bichelsee-Balterswil",
                    "state": "Nidwalden",
                    "country": "Switzerland",
                    "postcode": 5706,
                    "coordinates": {
                        "latitude": "-56.9584",
                        "longitude": "-15.8737"
                    },
                    "timezone": {
                        "offset": "+7:00",
                        "description": "Bangkok, Hanoi, Jakarta"
                    }
                },
                "email": "levin.lecomte@example.com",
                "login": {
                    "uuid": "98dc418d-0859-40da-9fd8-3cc18c47894e",
                    "username": "ticklishlion294",
                    "password": "wendy",
                    "salt": "dHwLa2OK",
                    "md5": "8075b3d5a4e52d95396a3a08ed2c32d3",
                    "sha1": "978cdc1bc2ae3ebb9d00277d2013406d43b9b8bf",
                    "sha256": "6734886223611d67bcc8aa0f2ae2b6b67d4a3efdc2f9cbed88cf6d46f4ff05bf"
                },
                "dob": {
                    "date": "1986-09-22T22:27:21.093Z",
                    "age": 34
                },
                "registered": {
                    "date": "2016-01-16T15:38:20.209Z",
                    "age": 4
                },
                "phone": "078 345 53 97",
                "cell": "078 849 67 32",
                "id": {
                    "name": "AVS",
                    "value": "756.9555.4941.23"
                },
                "picture": {
                    "large": "https://randomuser.me/api/portraits/men/7.jpg",
                    "medium": "https://randomuser.me/api/portraits/med/men/7.jpg",
                    "thumbnail": "https://randomuser.me/api/portraits/thumb/men/7.jpg"
                },
                "nat": "CH"
            },
            {
                "gender": "male",
                "name": {
                    "title": "Mr",
                    "first": "Ramon",
                    "last": "Pastor"
                },
                "location": {
                    "street": {
                        "number": 5718,
                        "name": "Avenida de La Albufera"
                    },
                    "city": "Vitoria",
                    "state": "Islas Baleares",
                    "country": "Spain",
                    "postcode": 44499,
                    "coordinates": {
                        "latitude": "52.1644",
                        "longitude": "52.8255"
                    },
                    "timezone": {
                        "offset": "+3:00",
                        "description": "Baghdad, Riyadh, Moscow, St. Petersburg"
                    }
                },
                "email": "ramon.pastor@example.com",
                "login": {
                    "uuid": "d6eac53f-9886-4f73-8562-db892fa657c0",
                    "username": "bluesnake609",
                    "password": "priest",
                    "salt": "tEVdAn62",
                    "md5": "65c42b7dc09a275e083c73fe67b37219",
                    "sha1": "e1b97e795ab668dbc06b64946fc91d7b4f6bc5a6",
                    "sha256": "10be84e132c33594e16a40ea9afdc8c0b886affaadc02b906d65d1366745041f"
                },
                "dob": {
                    "date": "1968-04-13T04:44:31.191Z",
                    "age": 52
                },
                "registered": {
                    "date": "2003-06-05T13:19:29.734Z",
                    "age": 17
                },
                "phone": "919-860-004",
                "cell": "641-316-162",
                "id": {
                    "name": "DNI",
                    "value": "13637232-S"
                },
                "picture": {
                    "large": "https://randomuser.me/api/portraits/men/15.jpg",
                    "medium": "https://randomuser.me/api/portraits/med/men/15.jpg",
                    "thumbnail": "https://randomuser.me/api/portraits/thumb/men/15.jpg"
                },
                "nat": "ES"
            },
            {
                "gender": "female",
                "name": {
                    "title": "Miss",
                    "first": "Paige",
                    "last": "Taylor"
                },
                "location": {
                    "street": {
                        "number": 8045,
                        "name": "Victoria Road"
                    },
                    "city": "Porirua",
                    "state": "Northland",
                    "country": "New Zealand",
                    "postcode": 59872,
                    "coordinates": {
                        "latitude": "-13.2487",
                        "longitude": "-103.5225"
                    },
                    "timezone": {
                        "offset": "-1:00",
                        "description": "Azores, Cape Verde Islands"
                    }
                },
                "email": "paige.taylor@example.com",
                "login": {
                    "uuid": "edb2d961-21ec-4b11-8661-5191a31495b3",
                    "username": "bigbear435",
                    "password": "tomcat",
                    "salt": "IFN3ChZS",
                    "md5": "2c6168b05797795baa3152d988cc4483",
                    "sha1": "c214de9a14eef9dd125331ac5405c63e22637835",
                    "sha256": "3b8aefae6c2e83eac238ab95bd84570297299f6777d298a4231c29b8d2b6aaf8"
                },
                "dob": {
                    "date": "1982-05-08T02:18:34.698Z",
                    "age": 38
                },
                "registered": {
                    "date": "2009-08-25T18:35:06.071Z",
                    "age": 11
                },
                "phone": "(663)-496-7213",
                "cell": "(533)-865-8232",
                "id": {
                    "name": "",
                    "value": null
                },
                "picture": {
                    "large": "https://randomuser.me/api/portraits/women/88.jpg",
                    "medium": "https://randomuser.me/api/portraits/med/women/88.jpg",
                    "thumbnail": "https://randomuser.me/api/portraits/thumb/women/88.jpg"
                },
                "nat": "NZ"
            },
            {
                "gender": "male",
                "name": {
                    "title": "Mr",
                    "first": "Gerardo",
                    "last": "Molina"
                },
                "location": {
                    "street": {
                        "number": 8873,
                        "name": "Calle de Bravo Murillo"
                    },
                    "city": "Las Palmas de Gran Canaria",
                    "state": "Comunidad Valenciana",
                    "country": "Spain",
                    "postcode": 76796,
                    "coordinates": {
                        "latitude": "-27.1861",
                        "longitude": "-88.2973"
                    },
                    "timezone": {
                        "offset": "+5:45",
                        "description": "Kathmandu"
                    }
                },
                "email": "gerardo.molina@example.com",
                "login": {
                    "uuid": "bdbcb56c-ea88-488a-971d-be105b6ea956",
                    "username": "organicleopard974",
                    "password": "venus",
                    "salt": "YAcq2Yuk",
                    "md5": "e7a44ee69cc16fc0f6e1af08c196a305",
                    "sha1": "5c6f8acf7c16a2b1d615fb8aae6a2325d7fb0f96",
                    "sha256": "9d00669fb82bf17103ba012cc547bd0d5368a03d1889d4ebac0461a2a3c0d269"
                },
                "dob": {
                    "date": "1967-07-25T14:47:22.049Z",
                    "age": 53
                },
                "registered": {
                    "date": "2007-08-18T05:25:06.542Z",
                    "age": 13
                },
                "phone": "993-357-190",
                "cell": "653-781-162",
                "id": {
                    "name": "DNI",
                    "value": "62999994-E"
                },
                "picture": {
                    "large": "https://randomuser.me/api/portraits/men/71.jpg",
                    "medium": "https://randomuser.me/api/portraits/med/men/71.jpg",
                    "thumbnail": "https://randomuser.me/api/portraits/thumb/men/71.jpg"
                },
                "nat": "ES"
            },
            {
                "gender": "male",
                "name": {
                    "title": "Monsieur",
                    "first": "Murat",
                    "last": "Nicolas"
                },
                "location": {
                    "street": {
                        "number": 406,
                        "name": "Rue de L'Abbaye"
                    },
                    "city": "Birr",
                    "state": "Nidwalden",
                    "country": "Switzerland",
                    "postcode": 5573,
                    "coordinates": {
                        "latitude": "81.0992",
                        "longitude": "45.5998"
                    },
                    "timezone": {
                        "offset": "+5:30",
                        "description": "Bombay, Calcutta, Madras, New Delhi"
                    }
                },
                "email": "murat.nicolas@example.com",
                "login": {
                    "uuid": "b326854e-b8d3-4446-b69c-e668bc604dc5",
                    "username": "yellowswan450",
                    "password": "78945612",
                    "salt": "dLJqWtEi",
                    "md5": "022c066f95063197ab4c18e5cf56790e",
                    "sha1": "ad7644a7e3a09682a11e74c3395056680c6ac4eb",
                    "sha256": "3dd2d9d530d86f7f1f4e2fd33c8d418dfcf596b2113ed9f7556763a7c2e78f70"
                },
                "dob": {
                    "date": "1977-05-29T00:55:31.970Z",
                    "age": 43
                },
                "registered": {
                    "date": "2003-10-26T20:07:26.727Z",
                    "age": 17
                },
                "phone": "076 161 60 78",
                "cell": "078 629 33 24",
                "id": {
                    "name": "AVS",
                    "value": "756.5301.6675.10"
                },
                "picture": {
                    "large": "https://randomuser.me/api/portraits/men/76.jpg",
                    "medium": "https://randomuser.me/api/portraits/med/men/76.jpg",
                    "thumbnail": "https://randomuser.me/api/portraits/thumb/men/76.jpg"
                },
                "nat": "CH"
            },
            {
                "gender": "male",
                "name": {
                    "title": "Mr",
                    "first": "Sabri",
                    "last": "Naber"
                },
                "location": {
                    "street": {
                        "number": 8883,
                        "name": "De Woldering"
                    },
                    "city": "Kraggenburg",
                    "state": "Drenthe",
                    "country": "Netherlands",
                    "postcode": 39773,
                    "coordinates": {
                        "latitude": "-59.8143",
                        "longitude": "158.7206"
                    },
                    "timezone": {
                        "offset": "-10:00",
                        "description": "Hawaii"
                    }
                },
                "email": "sabri.naber@example.com",
                "login": {
                    "uuid": "98f64bf5-49c2-4e08-9bd3-2b494fefee62",
                    "username": "reddog284",
                    "password": "titleist",
                    "salt": "QDQAOmhJ",
                    "md5": "b84d33b74f8358fd6fd82da050b954bf",
                    "sha1": "23b46bbc8eced4792bc5ff275f1b4764b480a611",
                    "sha256": "bb437c37174c2879cfa2617149fd9bdcf1bc61295f71f1ea71c61d62b4aa6d9f"
                },
                "dob": {
                    "date": "1995-09-23T22:19:44.776Z",
                    "age": 25
                },
                "registered": {
                    "date": "2010-01-15T21:34:29.211Z",
                    "age": 10
                },
                "phone": "(500)-519-9482",
                "cell": "(238)-962-8641",
                "id": {
                    "name": "BSN",
                    "value": "82491313"
                },
                "picture": {
                    "large": "https://randomuser.me/api/portraits/men/43.jpg",
                    "medium": "https://randomuser.me/api/portraits/med/men/43.jpg",
                    "thumbnail": "https://randomuser.me/api/portraits/thumb/men/43.jpg"
                },
                "nat": "NL"
            },
            {
                "gender": "female",
                "name": {
                    "title": "Miss",
                    "first": "Emily",
                    "last": "Mortensen"
                },
                "location": {
                    "street": {
                        "number": 9047,
                        "name": "Fuglebakken"
                    },
                    "city": "St.Merløse",
                    "state": "Nordjylland",
                    "country": "Denmark",
                    "postcode": 89705,
                    "coordinates": {
                        "latitude": "-54.5330",
                        "longitude": "-117.5216"
                    },
                    "timezone": {
                        "offset": "+5:45",
                        "description": "Kathmandu"
                    }
                },
                "email": "emily.mortensen@example.com",
                "login": {
                    "uuid": "bcb08181-0994-4c57-a0fd-691c8529290c",
                    "username": "heavydog391",
                    "password": "phoenix1",
                    "salt": "WfpZeRvD",
                    "md5": "516f2e2a88c6672ce64fa5d85be67811",
                    "sha1": "fdcbbf8575b432631dae6e81ae2735d65403b45d",
                    "sha256": "959133bdafa09c23c2907514f53ad6ecd643d8a062f908b8bc89792d68ceba06"
                },
                "dob": {
                    "date": "1953-12-20T17:01:20.505Z",
                    "age": 67
                },
                "registered": {
                    "date": "2009-11-08T10:13:45.870Z",
                    "age": 11
                },
                "phone": "91530195",
                "cell": "13179874",
                "id": {
                    "name": "CPR",
                    "value": "201253-4403"
                },
                "picture": {
                    "large": "https://randomuser.me/api/portraits/women/63.jpg",
                    "medium": "https://randomuser.me/api/portraits/med/women/63.jpg",
                    "thumbnail": "https://randomuser.me/api/portraits/thumb/women/63.jpg"
                },
                "nat": "DK"
            },
            {
                "gender": "male",
                "name": {
                    "title": "Mr",
                    "first": "Rafael",
                    "last": "Gutierrez"
                },
                "location": {
                    "street": {
                        "number": 9567,
                        "name": "Calle de Téllez"
                    },
                    "city": "Fuenlabrada",
                    "state": "Navarra",
                    "country": "Spain",
                    "postcode": 95848,
                    "coordinates": {
                        "latitude": "69.7127",
                        "longitude": "68.0580"
                    },
                    "timezone": {
                        "offset": "-11:00",
                        "description": "Midway Island, Samoa"
                    }
                },
                "email": "rafael.gutierrez@example.com",
                "login": {
                    "uuid": "a4f55378-501a-4ac9-a0c2-c71e6705b7a6",
                    "username": "blackwolf138",
                    "password": "sonja",
                    "salt": "DZTqBXGw",
                    "md5": "3a398422b8d382dcf8fb65f26636cbe7",
                    "sha1": "e6762c20724381d578f0549c9f19d3415b4215aa",
                    "sha256": "f0eabd07a43723b2142f6eecd928e005f80af804523e342d945c5a973199b8a5"
                },
                "dob": {
                    "date": "1989-04-18T14:20:11.656Z",
                    "age": 31
                },
                "registered": {
                    "date": "2017-01-23T01:26:13.068Z",
                    "age": 3
                },
                "phone": "904-653-355",
                "cell": "644-397-814",
                "id": {
                    "name": "DNI",
                    "value": "91185102-T"
                },
                "picture": {
                    "large": "https://randomuser.me/api/portraits/men/30.jpg",
                    "medium": "https://randomuser.me/api/portraits/med/men/30.jpg",
                    "thumbnail": "https://randomuser.me/api/portraits/thumb/men/30.jpg"
                },
                "nat": "ES"
            },
            {
                "gender": "female",
                "name": {
                    "title": "Miss",
                    "first": "Petra",
                    "last": "Elden"
                },
                "location": {
                    "street": {
                        "number": 5102,
                        "name": "Bjørnstadbakken"
                    },
                    "city": "Lia",
                    "state": "Trøndelag",
                    "country": "Norway",
                    "postcode": "4673",
                    "coordinates": {
                        "latitude": "27.9692",
                        "longitude": "-104.7327"
                    },
                    "timezone": {
                        "offset": "+9:30",
                        "description": "Adelaide, Darwin"
                    }
                },
                "email": "petra.elden@example.com",
                "login": {
                    "uuid": "19eb23f7-6910-491f-a7c3-35cfa3db71d4",
                    "username": "purplegorilla238",
                    "password": "159357",
                    "salt": "BFrFC96z",
                    "md5": "d1c31fae425757e003b071ef76b9ad40",
                    "sha1": "a3b259523754e8fddb84aac396bbe8a7f0d9276e",
                    "sha256": "de4df4ee81ea6ffca2e242cf37487714b957459866e6d713c3704ab571233bf0"
                },
                "dob": {
                    "date": "1988-01-12T00:14:56.135Z",
                    "age": 32
                },
                "registered": {
                    "date": "2006-04-01T22:36:15.229Z",
                    "age": 14
                },
                "phone": "29197858",
                "cell": "47087342",
                "id": {
                    "name": "FN",
                    "value": "12018820895"
                },
                "picture": {
                    "large": "https://randomuser.me/api/portraits/women/84.jpg",
                    "medium": "https://randomuser.me/api/portraits/med/women/84.jpg",
                    "thumbnail": "https://randomuser.me/api/portraits/thumb/women/84.jpg"
                },
                "nat": "NO"
            },
            {
                "gender": "female",
                "name": {
                    "title": "Ms",
                    "first": "Franka",
                    "last": "Alex"
                },
                "location": {
                    "street": {
                        "number": 3760,
                        "name": "Breslauer Straße"
                    },
                    "city": "Brand-Erbisdorf",
                    "state": "Hamburg",
                    "country": "Germany",
                    "postcode": 66095,
                    "coordinates": {
                        "latitude": "-16.3066",
                        "longitude": "154.5203"
                    },
                    "timezone": {
                        "offset": "+3:30",
                        "description": "Tehran"
                    }
                },
                "email": "franka.alex@example.com",
                "login": {
                    "uuid": "25145848-2ce3-4c8e-814d-1b57b73526ae",
                    "username": "crazysnake971",
                    "password": "shelter",
                    "salt": "0ppkbV6b",
                    "md5": "c4fd8790c68f31694dbd5318083e24a6",
                    "sha1": "2703cab1c9782b93c35b227b0dd256e0ea9546b9",
                    "sha256": "a7b3629bd8978a3f70d852106879165556dffbc17fabf5697d0a6477415cb250"
                },
                "dob": {
                    "date": "1950-02-20T00:43:46.509Z",
                    "age": 70
                },
                "registered": {
                    "date": "2008-03-20T16:35:57.718Z",
                    "age": 12
                },
                "phone": "0872-7474735",
                "cell": "0176-7688066",
                "id": {
                    "name": "",
                    "value": null
                },
                "picture": {
                    "large": "https://randomuser.me/api/portraits/women/26.jpg",
                    "medium": "https://randomuser.me/api/portraits/med/women/26.jpg",
                    "thumbnail": "https://randomuser.me/api/portraits/thumb/women/26.jpg"
                },
                "nat": "DE"
            }
        ],
        "info": {
            "seed": "9886de4e68a36c6b",
            "results": 10,
            "page": 1,
            "version": "1.3"
        }
    }
    """.data(using: .utf8)!
  }
}
// swiftlint:enable type_body_length
