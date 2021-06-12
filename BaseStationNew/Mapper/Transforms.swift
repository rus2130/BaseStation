import Foundation


var bsNames = [
    "BTS3900 (UMTS)":"Huawei",
    "BTS3900A (UMTS)":"Huawei",
    "BTS3900L (UMTS)":"Huawei",
    
    "RBS6501 (UMTS)":"Erricson",
    "RADIO 2219 (UMTS)":"Erricson",
    "RADIO 2212 (LTE-900)":"Erricson",
    
    "DBS3900 (UMTS) з віддаленим р/ч блоком":"Huawei",
    
    "BTS3900 (LTE-900) з віддаленим р/ч блоком":"Huawei",
    "BTS3900 (LTE-1800)":"Huawei",
    "BTS3900 (GSM-1800)":"Huawei",
    "BTS3900 (GSM-900)":"Huawei",
    "BTS3900A (GSM-1800)":"Huawei",
    "BTS3900A (GSM-900)":"Huawei",
    "BTS3900L (GSM-900)":"Huawei",
    "BTS3900Е (GSM-1800)":"Huawei",
    
    "BTS3900A (LTE-1800)":"Huawei",
    "Pico BTS 3900B (GSM-1800)":"Huawei",
    "DBS3900 (LTE-1800) з віддаленим р/ч блоком":"Huawei",
    
    
    "RBS6102 (LTE-1800)":"Erricson",
    "RADIO 4415 (LTE-1800)":"Erricson",
    "RADIO 2212 (GSM-900)":"Erricson",
    "RADIO 2217 (GSM-900)":"Erricson",
    "RADIO 4415 (GSM-1800)":"Erricson",
    "RBS6201 (LTE-1800)":"Erricson",
    "RBS6201 (LTE-900)":"Erricson",
    "RBS2000 (GSM-1800)":"Erricson",
    "RBS2000 (GSM-900)":"Erricson",
    "RBS2106 (GSM-1800)":"Erricson",
    "RBS2106 (GSM-900)":"Erricson",
    "RBS2111 (GSM-1800)":"Erricson",
    "RBS2111 (GSM-900)":"Erricson",
    "RBS2116 (GSM-1800)":"Erricson",
    "RBS2116 (GSM-900)":"Erricson",
    "RBS2206 (GSM-1800)":"Erricson",
    "RBS2206 (GSM-900)":"Erricson",
    "RBS2207 (GSM-1800)":"Erricson",
    "RBS2207 (GSM-900)":"Erricson",
    "RBS2216 (GSM-1800)":"Erricson",
    "RBS2216 (GSM-900)":"Erricson",
    "RBS2308 (GSM-1800)":"Erricson",
    "RBS2308 (GSM-900)":"Erricson",
    "RBS6101 (GSM-1800)":"Erricson",
    "RBS6102 (GSM-1800)":"Erricson",
    "RBS6102 (GSM-900)":"Erricson",
    "RBS6201 (GSM-1800)":"Erricson",
    "RBS6201 (GSM-900)":"Erricson",
    "RBS6301 (GSM-1800)":"Erricson",
    "RBS6301 (GSM-900)":"Erricson",
    "RBS6601 (GSM-1800)":"Erricson",
    "RBS6601 (GSM-900)":"Erricson",
    
    "DBS3900 (LTE-1800)":"Huawei",
    "DBS3900 (LTE-900) з віддаленим р/ч блоком":"Huawei",
    "BTS 3900 (LTE-1800)":"Huawei",
    "BTS 3900A (LTE-1800)":"Huawei",
    "DBS3900 з віддаленим радіочастотним блоком":"Huawei",
    "DBS3900 (UMTS)":"Huawei",
    "DBS3900 (GSM-1800) з віддаленим р/ч блоком":"Huawei",
    "DBS3900 (GSM-900) з віддаленим р/ч блоком":"Huawei",
    "DTS 3803C":"Huawei",
    "BTS 3900L (UMTS)":"Huawei",
    "DBS 3800":"Huawei",
    "BTS3812A":"Huawei",
    "BTS3812E":"Huawei",
    "BTS 3900 (UMTS)":"Huawei",
    "BTS Supreme Outdoor (UMTS)":"Huawei",
    "BTS 3900А (UMTS)":"Huawei",
    "BTS Optima Compact Outdoor (UMTS)":"Huawei",
    "ZXSDR BS8700 (LTE-1800)":"ZTE",
    "ZXSDR BS8700 із зовнішнім блоком RRU":"ZTE",
    
    "ZXSDR BS8700 (LTE-1800) із зовнішнім блоком RRU":"ZTE",
    "ZXSDR BS8700 (UMTS)":"ZTE",
    "ZXSDR BS8700 (LTE-900)":"ZTE",
    "ZXSDR BS8700 (GSM-1800)":"ZTE",
    "ZXSDR BS8700 (GSM-900)":"ZTE",
    "RBS 6102 (LTE-1800)":"Erricson",
    "RBS 6201 (LTE-1800)":"Erricson",
    "Radio 4415":"Erricson",
    "RBS6101 (UMTS)":"Erricson",
    "RBS6601 (UMTS)":"Erricson",
    "RBS3418 (UMTS)":"Erricson",
    "RBS2116 (UMTS)":"Erricson",
    "RBS6302 (UMTS)":"Erricson",
    "RBS6201 (UMTS)":"Erricson",
    "RBS6102 (UMTS)":"Erricson",
    "RBS3518 (UMTS)":"Erricson",
    "RBS6301 (UMTS)":"Erricson",
    "RBS6102":"Erricson",
    "RBS6201":"Erricson",
    "RBS 3206":"Erricson",
    "Flexi Multiradio 10 Base Station (LTE-1800)":"Nokia",
    "Flexi Multiradio 10 Base Station":"Nokia",
    "Flexi Multiradio 10 BTS (GSM-1800)":"Nokia",
    "Flexi Multiradio 10 BTS (GSM-900)":"Nokia",
    "Flexi Multiradio BTS (GSM-1800)":"Nokia",
    "Nokia MetroSite 50 BTS":"Nokia",
    "Nokia Ultra Site WCDMA BTS Supreme Indoor (UMTS)":"Nokia",
    "Nokia Ultra Site WCDMA BTS (UMTS)":"Nokia",
    "Nokia Ultra Site EDGE BTS (GSM-1800)":"Nokia",
    "Nokia UltraSite EDGE BTS (GSM-1800)":"Nokia",
    "Nokia Flexi WCDMA BTS (UMTS)":"Nokia",
    "Nokia Flexi EDGE BTS (GSM-1800)":"Nokia",
    "Nokia Ultra Site WCDMA BTS Optima (UMTS)":"Nokia",
    "Flexi Multiradio 10 BTS (UMTS)":"Nokia",
    "Flexi Multiradio 10 Base Station (LTE-900)":"Nokia",
    "Siemens nanoBTS 165AU (GSM-1800)":"Siemens",
    "Повторювач MobileAccess GX (UMTS)":"Інші",
    "Повторювач MobileAccess GX (GSM-1800)":"Інші"
]


var freqOps = [
    "1725-1750":"Kyivstar",
    "1730-1750":"Kyivstar",
    "1750-1770":"Vodafone",
    "1755-1770":"Vodafone",
    "1710-1725":"Lifecell",         //LTE1800
    
   
    "2535-2545": "Lifecell",
    "2520-2535": "Kyivstar",
    "2510-2520": "Vodafone",
    "2515-2520": "Vodafone",
    "2520": "Kyivstar",             //LTE2600
    
    "895-900": "Lifecell",
    "890-895": "Kyivstar",
    "900-905": "Vodafone",          //LTE900
    
    
    "1967": "Kyivstar",
    "1952": "Vodafone",
    "1922": "Lifecell",
    "1922,8,  1927,6,  1932,4, 1922,8,  1927,6,  1932,4, 1922,8,  1927,6,  1932,4": "Lifecell",                             //UMTS
   
    
    
    "1750.200":"Vodafone",
    "1710.200":"Lifecell",
    "1725.200":"Kyivstar",
    
    "900.200":"Vodafone",
    "895.200":"Lifecell",
    "890.000":"Kyivstar"
    
    
    
    
    
    
]


var regionsString = ["Вінницька", "Волинська", "Дніпропетровська", "Донецька", "Житомирська", "Закарпатська", "Запорізька", "Івано-Франківська", "Київ", "Київська", "Кіровоградська", "Луганська", "Львівська", "Миколаївська", "Одеська", "Полтавська", "Рівненська", "Сумська", "Тернопільська", "Харківська", "Херсонська", "Хмельницька", "Черкаська", "Чернівецька", "Чернігівська"]

//var providersEnum = [Providers.kyivstar, Providers.vodafone, Providers.lifecell, Providers.invalid]


