'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {".git/COMMIT_EDITMSG": "bfa25d06d8a414f1455279412dc5c6cd",
".git/config": "f4455fd419b149daec81abea9511feef",
".git/description": "a0a7c3fff21f2aea3cfa1d0316dd816c",
".git/FETCH_HEAD": "9092722aa0945938fde035362442aa38",
".git/HEAD": "5ab7a4355e4c959b0c5c008f202f51ec",
".git/hooks/applypatch-msg.sample": "ce562e08d8098926a3862fc6e7905199",
".git/hooks/commit-msg.sample": "579a3c1e12a1e74a98169175fb913012",
".git/hooks/fsmonitor-watchman.sample": "a0b2633a2c8e97501610bd3f73da66fc",
".git/hooks/post-update.sample": "2b7ea5cee3c49ff53d41e00785eb974c",
".git/hooks/pre-applypatch.sample": "054f9ffb8bfe04a599751cc757226dda",
".git/hooks/pre-commit.sample": "5029bfab85b1c39281aa9697379ea444",
".git/hooks/pre-merge-commit.sample": "39cb268e2a85d436b9eb6f47614c3cbc",
".git/hooks/pre-push.sample": "2c642152299a94e05ea26eae11993b13",
".git/hooks/pre-rebase.sample": "56e45f2bcbc8226d2b4200f7c46371bf",
".git/hooks/pre-receive.sample": "2ad18ec82c20af7b5926ed9cea6aeedd",
".git/hooks/prepare-commit-msg.sample": "2b5c047bdb474555e1787db32b2d2fc5",
".git/hooks/push-to-checkout.sample": "c7ab00c7784efeadad3ae9b228d4b4db",
".git/hooks/sendemail-validate.sample": "4d67df3a8d5c98cb8565c07e42be0b04",
".git/hooks/update.sample": "647ae13c682f7827c22f5fc08a03674e",
".git/index": "f1919fcc6a9a14d1e1b9588e919228ed",
".git/info/exclude": "036208b4a1ab4a235d75c181e685e5a3",
".git/logs/HEAD": "d326dc2923e225deb17167ec2f31fd2c",
".git/logs/refs/heads/gh-pages": "d326dc2923e225deb17167ec2f31fd2c",
".git/logs/refs/remotes/origin/gh-pages": "8ac214a1d4cb755cca108f176a6f1770",
".git/logs/refs/remotes/origin/main": "a46c1c84cc4966e328c80f8dcaeb2426",
".git/objects/01/42d6131e578bc9e09dbb59c8cd8aa49bf17a1d": "b792924c24f4674d1fc0f19992c6ca54",
".git/objects/05/4ecbc5341f4fda2a92bf0129ffbe03bd013f25": "4fa11478743e44f7562402336ba28ec9",
".git/objects/08/27c17254fd3959af211aaf91a82d3b9a804c2f": "360dc8df65dabbf4e7f858711c46cc09",
".git/objects/0a/21c1c46309344e93b5bb5c09671c09fe3918c4": "4f371c096d55c8df9834dbaabe4bdce6",
".git/objects/0c/acac3dccb9f2a5cb5daf0b89e322cd8d7ba40e": "817a09f4deb5a672566e1f84b4a1d2f1",
".git/objects/0d/2902135caece481a035652d88970c80e29cc7e": "dfc8c4c4b7d0a1b6dbadc04d9fa6e6f1",
".git/objects/11/868bb5f72913acdcb1b510bc141b6d9ec14a66": "a7a8b3c9d083b94cbf07ac802c5a1fba",
".git/objects/15/021310b2aa70356a38e20f8f7de1759b51d9f7": "98be403b9c1fe11f68d2181960ed8a96",
".git/objects/15/b1ea1936cb2338f131dbb731129c28d4ebaa0e": "1aee80c31e71468e7703be7ab28544af",
".git/objects/1b/8e44dfe15543fc519f5d6a569cf0a16d234bb6": "dd51bfd4fc210308ff4dc83979633829",
".git/objects/1c/e6625b4e103f211ba811c72b1a9945a32a53dd": "5ff2a7f5920b0c355ca61f581d9c48e6",
".git/objects/1d/69f73f333245b6378d1972bdbef9716a7ea657": "18e517e0474ef9e0622b7d63e54ec551",
".git/objects/23/7572ae929ce0a66ed33090556b12efa5bcc2e9": "cc2b47e98935562c629735578b7d4632",
".git/objects/25/8d0ad8f196c05c4af89c622a0370af5e811c03": "c16630edafda1e63c4db805a8bf87877",
".git/objects/26/21a8ec9fd6fb4dcc4b2fb2c1537a05969fcc2c": "8f0482bdfa6febae4713126b2e06e663",
".git/objects/26/978fa377a82a490f30c5175402c7f0796994bc": "d1800fd8df915bee17ba82bd6bf19e33",
".git/objects/28/0e9c4b475cd9a027af95d3ce1e2d8200679fa8": "48b7a914b91cc53b38fe832774cb4af9",
".git/objects/29/3f218b075605bbc4951edfe2e5b2450fe3e60d": "07a9c6c2ba873907870f3ac57b344f45",
".git/objects/2a/4a690990049a6eefbf5d8c8c96b95921d47a47": "13e252565143e07919769fc5fa7ef9ce",
".git/objects/31/bb0a3f78b20ae58c3f767f89754585637e453a": "3bb5b5357d0a67dcd9bcb0fbbcd1f270",
".git/objects/38/20a95c65c3e5983cc66d481e2e68706a750090": "75ff997c33a1c519a1a869376af24550",
".git/objects/3a/8cda5335b4b2a108123194b84df133bac91b23": "1636ee51263ed072c69e4e3b8d14f339",
".git/objects/3e/33682148afc5cbc766672996cd9f5205aed99b": "e93c04c456047995de8c74e15f53fc8c",
".git/objects/41/161f60ca6d3a85a5313aede1458e426a45ad53": "2f823af5509cb90ca25a5a4ddf296a3d",
".git/objects/42/4877a1b46e3d1afd189bf2d575e2050a9ccc3a": "80b5230517b985bedf645c04279dad05",
".git/objects/42/9698e577da3586419b2f47a913c8874e00b1a2": "ece3aeb1a503f75332d1ee742e542ebc",
".git/objects/48/eaaac605fb612ce1a532755500b9c35ed9fd3d": "2b8d714c3d3d1ae51c32735ba0f3fb05",
".git/objects/4c/76c580d08efa943582fa7cd50d46e6877787e4": "243a24fa76405e6036af6b9a69e823c4",
".git/objects/4d/5887e6caca3262bc58eabf91d6f6984d48e4de": "b671373180c4e14d47dd45f35c8d34e1",
".git/objects/4d/8d07251352488dae6f9e4142f961bf04e2a1da": "83d9d44d3a187993e414ff751b00f200",
".git/objects/4e/4246237e69907988a8922f7af09a01e058a318": "7d8e2a6af90b0a7813c935deb3cb97a7",
".git/objects/4f/f3786051ab6265a49344388f607309fb80c5a1": "6a4af3c54f4925f7f2922db640188fe4",
".git/objects/51/03e757c71f2abfd2269054a790f775ec61ffa4": "d437b77e41df8fcc0c0e99f143adc093",
".git/objects/51/060b94e41b6f6c946b7f56d36e98a634bb197c": "efb51994c198dc0907dcf2f76d07b842",
".git/objects/53/4956ef2690f077665e11dc810f80ec28800e63": "d32bc3c0b5d6a9ccb7cd152f92c9325a",
".git/objects/54/91cb82ce9000b0757444c7fcd27957c0053f95": "5368c6ed7f175aa414f91c4318e5a5e9",
".git/objects/55/b89a0f934e2ecd79dbd565b65022da358e706d": "8881858cf34ca023ee2310d61807ea44",
".git/objects/59/f6d3a3b9376ee6f91b2719fe70dd22f4f105e1": "2d46714f65b94dd8c3943de5fcc717c9",
".git/objects/5b/9a925dad4143607203f94c732f59a1be67b790": "91e3d1e4c83b874c6fe1a4023fa87024",
".git/objects/5c/8da37e7ceb07970cb84fa323d9a39416d3f1f3": "1bfb5bacebd72da0815e23073801fc5f",
".git/objects/5d/2ba83620fb5358cad37153f32b2572e0c4fb61": "20f2aed16bb220157737b49babcf4cde",
".git/objects/5d/556148bd2dd8820d425785e2e73bbe73c545c6": "1aa791ca83b6b7e894b4099d6ebe3416",
".git/objects/5e/985b040ed915747172cc055e19ee83b139fa2a": "c9c217f13a46a83f915f50fdce2ac984",
".git/objects/65/0452ca422043f63c8849f5aabc1a2bd32d2a2b": "6eb4ad1b82c636505416a0c7f09f8946",
".git/objects/65/982e15276d581ebb2f652a6417c85cfff33796": "a46625f44d8a7a97c6a45c809bb3e438",
".git/objects/65/c73ab2b019f756ffed736474052011cec08bf8": "0150eaedff6dda8b3ccbc4796a7c30d5",
".git/objects/67/0df7eecd686be12b7e4cdc157e9be6850f9928": "76cd0d0cf4901159c04cf90ab49e3a66",
".git/objects/67/d622dd2f96f4d8f0b7619e737e5bff972f570a": "720dfeb86b73f4fcd989f8c21941a997",
".git/objects/68/00f5f3c387a480ff5c1a885ef6568a9558e9f2": "86942ea4098bb454e96f5cd9facac93e",
".git/objects/68/43fddc6aef172d5576ecce56160b1c73bc0f85": "2a91c358adf65703ab820ee54e7aff37",
".git/objects/6b/9862a1351012dc0f337c9ee5067ed3dbfbb439": "85896cd5fba127825eb58df13dfac82b",
".git/objects/6c/2f79c5a3a0a685552b682d642678919fb1db5c": "24afbdc2f31b83eb1c70fc8927642ddd",
".git/objects/6f/7661bc79baa113f478e9a717e0c4959a3f3d27": "985be3a6935e9d31febd5205a9e04c4e",
".git/objects/75/7a1883a6e04f5c378355725d4bf5fbbd62e221": "9b623f994488ee62d074a5087b4776ef",
".git/objects/75/d506eca0c1492f0fa887fab49e7e977652e382": "69a08e2ed147fbc46814c914d86af900",
".git/objects/76/09c748b557002680ea997ccef5604824c58338": "f7e3ebeab765b98218365d70c923f3ac",
".git/objects/7c/3463b788d022128d17b29072564326f1fd8819": "37fee507a59e935fc85169a822943ba2",
".git/objects/7e/9cd504a1dc09d24b18e669312c0f3146e52295": "339d914a1d37e8b13b368f177189488e",
".git/objects/82/5005a46b232807072d25c9868488b94db6fe02": "2beaa9424306e76cd58a82d338a52fdf",
".git/objects/84/d0574d55784f4279d124af24968da9b1de5acb": "1de9f3190f418c165dfdab74968af2f1",
".git/objects/85/03ae81cfb93e7882dd02c83a3ac97de4d93b14": "28a11e7e2008869fda88bc7a5d2c7079",
".git/objects/85/08630a35025bc828edcc5a3d2b7d88753d4bf9": "4a8e978a67f61a226d4eb33a371ab201",
".git/objects/85/20bed9e92432ef45db3fb2d21fca077c4f8052": "5795dee9c49096583a89363f4dbff5d5",
".git/objects/85/63aed2175379d2e75ec05ec0373a302730b6ad": "997f96db42b2dde7c208b10d023a5a8e",
".git/objects/85/d5d45d3b51bdc0912282e4a24f65d13d7ad2a8": "f3d93618dc92009fdeef1463766ee73a",
".git/objects/86/a2d45427a7d2bd3029da0ccf9893eb4d8bad94": "3be5ff1861a4edb2d2b8659e929dbd99",
".git/objects/86/e9f289623dfe1d3b1c8c0b0bcb6b1e7c9cfa48": "ddd312c5a12b309c9bae4019efbbdc04",
".git/objects/88/28e4b1939a9a79cb49acc84f603cebe3d79e91": "8d0a48af529f42ba10809d5a09ee3b93",
".git/objects/88/cfd48dff1169879ba46840804b412fe02fefd6": "e42aaae6a4cbfbc9f6326f1fa9e3380c",
".git/objects/8a/aa46ac1ae21512746f852a42ba87e4165dfdd1": "1d8820d345e38b30de033aa4b5a23e7b",
".git/objects/8b/65d6769638da86fd93dcb44cb4fc64cf34a4b3": "7fcb99e764c2569e3ffebad6237e8641",
".git/objects/8b/dfd25ec2678e558d35e65fbc8db504dbf405db": "e6a6b4c245d45b2fe9e90c44bfd65a59",
".git/objects/8c/b86d2e915a8eb6d4fab86d698585910cc08742": "18dae501ee0121606eb5ee15e93851aa",
".git/objects/8d/b4984ef99d615e64f244811b3211965ad4abad": "31de28dc763a47c2bd8b603b38304cf0",
".git/objects/8e/21753cdb204192a414b235db41da6a8446c8b4": "1e467e19cabb5d3d38b8fe200c37479e",
".git/objects/91/6b7c9e215384b26c746e9913c35552286e93fd": "881efbe173ffbc4bd19c029659247509",
".git/objects/93/b363f37b4951e6c5b9e1932ed169c9928b1e90": "c8d74fb3083c0dc39be8cff78a1d4dd5",
".git/objects/96/13469bc4783cdeb80d6faa19f0858733dfd800": "8c6049059a6df043cb5d4754489b1e2f",
".git/objects/97/b0b95e25b027b85671f49618725e93018fbdf4": "afa1bc5fc0880318798095fc7b982b42",
".git/objects/9d/7a6a944ac40ac55cac7fc78abeb437f4713825": "6b0f226b36ebc91ba896c6aa5d0b7173",
".git/objects/a7/3f4b23dde68ce5a05ce4c658ccd690c7f707ec": "ee275830276a88bac752feff80ed6470",
".git/objects/a7/d2705a0d75d8554cfa42fbdfb12836ff133add": "f3e58138da70d775828626eff095ef09",
".git/objects/ad/ced61befd6b9d30829511317b07b72e66918a1": "37e7fcca73f0b6930673b256fac467ae",
".git/objects/ae/e7d0fb7e66a5a153f956e24129f24b8c479d3e": "5f44c3649a98db31cfaa554f07b5472a",
".git/objects/b2/58b8404e5c8422b1ad4acbe7f1b968fa0897a5": "9fa6334182a49d04d63a3ec203f8da3c",
".git/objects/b2/8e9bebf1281d08f35d9b6178e3527e4f824fe2": "96256309193e29c98955dd54003abfb6",
".git/objects/b3/a80bf2be53cf89fd1e331869d6a0ed37404607": "28cc4b1df594f903a2d4dda79db87e28",
".git/objects/b7/49bfef07473333cf1dd31e9eed89862a5d52aa": "36b4020dca303986cad10924774fb5dc",
".git/objects/b9/2a0d854da9a8f73216c4a0ef07a0f0a44e4373": "f62d1eb7f51165e2a6d2ef1921f976f3",
".git/objects/b9/3e39bd49dfaf9e225bb598cd9644f833badd9a": "666b0d595ebbcc37f0c7b61220c18864",
".git/objects/bb/3cf1488f0ee24a61b427b06e2612401b697849": "b8a92d8487a347fde273d4787ed0dd71",
".git/objects/bc/ab7fa856c1ed390c121809c7dadb9799365ab7": "38851ffd0fe6187c37fbc06c32f4f5ad",
".git/objects/c3/1fd0b25f5c8111443b008bdb344a4b8495b4f9": "6a5802fd93c23b446375be0361b55c08",
".git/objects/c3/75bb0ec2644a9c2b6354ef49a1f34761dc3b29": "18acb90c10d7a921093c2cbd72025c13",
".git/objects/c3/fe14fc12a458b86b89a578d9fb08b8abc2d137": "039fd3f52738e6b4967343c71dca7f11",
".git/objects/c4/ebad28239876de1b986a2427376b077c1a0220": "c7098e473a1fff4a06cf5b48046ed03b",
".git/objects/c8/3af99da428c63c1f82efdcd11c8d5297bddb04": "144ef6d9a8ff9a753d6e3b9573d5242f",
".git/objects/c8/ff16555b56394ec8181ca0eaa0fef3ed250d58": "d91a5adfe50c720bfc9b355621c6ac35",
".git/objects/cc/09c7f5fcf313453eca24f8ceec4f8fbfc1d225": "9461d3028da79a0612a5279bb9791892",
".git/objects/cc/54f85d02d2fd5c8b786fa1c1207f1d0b69364c": "b423d3362fb7d071324742bc6fdfffb0",
".git/objects/cc/7cf42f381c09adabb3b6ed212a2f29faf6c975": "fda2b435e38ebb3aa42306f4d631af53",
".git/objects/cf/363333aa531cd2009114544c173fd0d0c1ee37": "b6ff2b6ad1af362bd983ced178ee1ea8",
".git/objects/d1/54dc51877ef392a1df8a9b0ca609193c097752": "7ca0153271c1b15b0dd71349f2508e0c",
".git/objects/d3/852f7adfae3c53bc34f14ffa6dbbc940ce0935": "0f03e26770f4ea8e02c60c77ba41cfd5",
".git/objects/d4/3532a2348cc9c26053ddb5802f0e5d4b8abc05": "3dad9b209346b1723bb2cc68e7e42a44",
".git/objects/d6/9c56691fbdb0b7efa65097c7cc1edac12a6d3e": "868ce37a3a78b0606713733248a2f579",
".git/objects/d8/7b8430be459825ea7764321cbbb21a434b5013": "74ab6f01e4958036e2d710a0b706f7ef",
".git/objects/d9/5b1d3499b3b3d3989fa2a461151ba2abd92a07": "a072a09ac2efe43c8d49b7356317e52e",
".git/objects/da/f98eb4f49dacde13be23f7e17fac21ae600fdf": "1688446db1a11e06ff71034297dde98f",
".git/objects/df/604f90fd3d0f9ebbcc97d474628a964eae45bf": "9d7a9c1797e181e2d7b5711c025db2e7",
".git/objects/e3/310f17bc63ac2283c69a9e6d9dd8872b81fa97": "b6d16e9d0c1ccc298da68c5f8bcbbe93",
".git/objects/e5/bdc13066c9f43a0aeebbb087fc58d591945cfe": "fa72c4d580d8470c98f106a04ccfef28",
".git/objects/e8/bed5c3a61944fe26adc1460965695efedd5153": "cef93a3b948da13e23716f96975eb485",
".git/objects/e9/94225c71c957162e2dcc06abe8295e482f93a2": "2eed33506ed70a5848a0b06f5b754f2c",
".git/objects/eb/9b4d76e525556d5d89141648c724331630325d": "37c0954235cbe27c4d93e74fe9a578ef",
".git/objects/ec/9976904b98e065230484f4bb043ea14ad70001": "2414ffbcc6d66bd4cd01de16ffbd8edb",
".git/objects/ee/0c1b5f99116152ffcb7ffd8e8b0db959020215": "93d2f7732560ab1a98b9cc3e093d4c1f",
".git/objects/ee/1c0cd83e158a9e600e8d73d7ec83980158a073": "a5bc514d21ac29a400a5c0e196467401",
".git/objects/ee/32a72778b0444b502027bd222204f7a0353e34": "c5c5ad7b51646496bcf6fb52f9612c8e",
".git/objects/ee/349d4ca75b2eab0353ed1a9e5aba428316562c": "bc55bd8a279678dcec4f8146a9ac2cd4",
".git/objects/ee/cfe427ef2f4b32d151cdab6f06d993255b81b5": "862b675a25fa52a064ebae2c8c4da580",
".git/objects/f1/20319e3f6dfd87b2034dbf3cfb09d8354bdf85": "5760cff2d8acdacb740fb369f6b6a6d7",
".git/objects/f3/3e0726c3581f96c51f862cf61120af36599a32": "afcaefd94c5f13d3da610e0defa27e50",
".git/objects/f5/72b90ef57ee79b82dd846c6871359a7cb10404": "e68f5265f0bb82d792ff536dcb99d803",
".git/objects/f6/e6c75d6f1151eeb165a90f04b4d99effa41e83": "95ea83d65d44e4c524c6d51286406ac8",
".git/objects/f7/0720152d55ced7e2679bde8c41dd61c9b53c99": "b03b0a8cf839d7e452e255ae7b8e6c45",
".git/objects/f7/3d951843fbbbc4ca4ce67fc38f6bd7cae13c0a": "9bf8a81dd9b1aebc12699000b4af5e55",
".git/objects/f9/0a87442bf6d382b688fa82a62692cf59936cf0": "0309a365f37f53e89233dda445f8c106",
".git/objects/fa/082421e156b49505bafd2fd20eeba3b43e5d93": "b1811b0cd0a13e806407e3e510834c88",
".git/objects/fa/0b357c4f4a29c3de7c5abfa47ba9ea8e52dd92": "9fab34b8519cc92f4e69673db8e68f2f",
".git/objects/fd/05cfbc927a4fedcbe4d6d4b62e2c1ed8918f26": "5675c69555d005a1a244cc8ba90a402c",
".git/refs/heads/gh-pages": "7d623d4b4d64aeabe5c1ad00afa1d035",
".git/refs/remotes/origin/gh-pages": "7d623d4b4d64aeabe5c1ad00afa1d035",
".git/refs/remotes/origin/main": "d8667cb00c344c2444965d62d9ca32a1",
"assets/AssetManifest.bin": "c70cf5c810235b7622a7b2faecf09709",
"assets/AssetManifest.bin.json": "8afe33ae86b37f1a873941b68232dd51",
"assets/FontManifest.json": "1a271d1659247e88b35f61c501b97786",
"assets/fonts/MaterialIcons-Regular.otf": "56095f7aad4ad584fc070358eb8b2cb8",
"assets/NOTICES": "a7486d995c877175f39d3923dcbcd27a",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/packages/lucide_icons/assets/lucide.ttf": "03f254a55085ec6fe9a7ae1861fda9fd",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"canvaskit/canvaskit.js": "8331fe38e66b3a898c4f37648aaf7ee2",
"canvaskit/canvaskit.js.symbols": "a3c9f77715b642d0437d9c275caba91e",
"canvaskit/canvaskit.wasm": "9b6a7830bf26959b200594729d73538e",
"canvaskit/chromium/canvaskit.js": "a80c765aaa8af8645c9fb1aae53f9abf",
"canvaskit/chromium/canvaskit.js.symbols": "e2d09f0e434bc118bf67dae526737d07",
"canvaskit/chromium/canvaskit.wasm": "a726e3f75a84fcdf495a15817c63a35d",
"canvaskit/skwasm.js": "8060d46e9a4901ca9991edd3a26be4f0",
"canvaskit/skwasm.js.symbols": "3a4aadf4e8141f284bd524976b1d6bdc",
"canvaskit/skwasm.wasm": "7e5f3afdd3b0747a1fd4517cea239898",
"canvaskit/skwasm_heavy.js": "740d43a6b8240ef9e23eed8c48840da4",
"canvaskit/skwasm_heavy.js.symbols": "0755b4fb399918388d71b59ad390b055",
"canvaskit/skwasm_heavy.wasm": "b0be7910760d205ea4e011458df6ee01",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"flutter_bootstrap.js": "f4c9582ce34811ad4455617d83adf9bb",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "7ce3c69c95d9a7fa03193f99b497ff69",
"/": "7ce3c69c95d9a7fa03193f99b497ff69",
"main.dart.js": "a1560bc9b9433a9b41f8205895a11a14",
"manifest.json": "dae4be674bd6a73204a45bdfb15a250f",
"version.json": "b8c81536c46c2f0a8d7fe76e09feffd8"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
