import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
class WordIneserter {
List<List<String>> places = [
  ["المطار", "Airport", "Places"],
  ["البنك", "Bank", "Places"],
  ["المستشفى", "Hospital", "Places"],
  ["المدرسة", "School", "Places"],
  ["المكتبة", "Library", "Places"],
  ["مكتب البريد", "Post Office", "Places"],
  ["السوبر ماركت", "Supermarket", "Places"],
  ["قسم الشرطة", "Police Station", "Places"],
  ["محطة الإطفاء", "Fire Station", "Places"],
  ["المول", "Mall", "Places"],
  ["الحديقة", "Park", "Places"],
  ["المتحف", "Museum", "Places"],
  ["المسرح", "Theater", "Places"],
  ["حديقة الحيوان", "Zoo", "Places"],
  ["السينما", "Cinema", "Places"],
  ["محطة الحافلات", "Bus Station", "Places"],
  ["محطة القطار", "Train Station", "Places"],
  ["الملعب", "Stadium", "Places"],
  ["المطعم", "Restaurant", "Places"],
  ["المقهى", "Café", "Places"],
  ["الشاطئ", "Beach", "Places"],
  ["الغابة", "Forest", "Places"],
  ["الجبل", "Mountain", "Places"],
  ["الصحراء", "Desert", "Places"],
  ["النهر", "River", "Places"],
  ["البحيرة", "Lake", "Places"],
  ["الشلال", "Waterfall", "Places"],
  ["الجزيرة", "Island", "Places"],
  ["الكهف", "Cave", "Places"],
  ["البركان", "Volcano", "Places"],
  ["المطبخ", "Kitchen", "Places"],
  ["الحمام", "Bathroom", "Places"],
  ["غرفة النوم", "Bedroom", "Places"],
  ["غرفة المعيشة", "Living Room", "Places"],
  ["الحديقة المنزلية", "Garden", "Places"],
  ["الكراج", "Garage", "Places"],
  ["الشرفة", "Balcony", "Places"],
  ["العلية", "Attic", "Places"],
  ["القبو", "Basement", "Places"],
  ["غرفة الطعام", "Dining Room", "Places"],
  ["برج إيفل", "Eiffel Tower", "Places"],
  ["سور الصين العظيم", "Great Wall of China", "Places"],
  ["الأهرامات", "Pyramids", "Places"],
  ["تايمز سكوير", "Times Square", "Places"],
  ["بيغ بن", "Big Ben", "Places"],
  ["تاج محل", "Taj Mahal", "Places"],
  ["تمثال الحرية", "Statue of Liberty", "Places"],
  ["الكولوسيوم", "Colosseum", "Places"],
  ["قمة إيفرست", "Mount Everest", "Places"],
  ["برج خليفة", "Burj Khalifa", "Places"],
  ["محطة الوقود", "Gas Station", "Places"],
  ["الطريق السريع", "Highway", "Places"],
  ["الحدود", "Border", "Places"],
  ["النفق", "Tunnel", "Places"],
  ["الجسر", "Bridge", "Places"],
  ["الميناء", "Harbor", "Places"],
  ["العبّارة", "Ferry", "Places"],
  ["القطار", "Train", "Places"],
  ["الطائرة", "Airplane", "Places"],
  ["سفينة الرحلات", "Cruise Ship", "Places"],
];

List<List<String>> people = [
  ["طبيب", "Doctor", "People"],
  ["معلم", "Teacher", "People"],
  ["مهندس", "Engineer", "People"],
  ["طيار", "Pilot", "People"],
  ["طاهٍ", "Chef", "People"],
  ["نادل", "Waiter", "People"],
  ["شرطي", "Police Officer", "People"],
  ["رجل إطفاء", "Firefighter", "People"],
  ["ممرضة", "Nurse", "People"],
  ["طبيب أسنان", "Dentist", "People"],
  ["مزارع", "Farmer", "People"],
  ["جندي", "Soldier", "People"],
  ["عالم", "Scientist", "People"],
  ["ممثل", "Actor", "People"],
  ["مغني", "Singer", "People"],
  ["رياضي", "Athlete", "People"],
  ["فنان", "Artist", "People"],
  ["مصور", "Photographer", "People"],
  ["كاتب", "Writer", "People"],
  ["صحفي", "Journalist", "People"],
  ["قاضٍ", "Judge", "People"],
  ["محامٍ", "Lawyer", "People"],
  ["سائق", "Driver", "People"],
  ["ميكانيكي", "Mechanic", "People"],
  ["سباك", "Plumber", "People"],
  ["كهربائي", "Electrician", "People"],
  ["نجار", "Carpenter", "People"],
  ["جزار", "Butcher", "People"],
  ["حلاق", "Barber", "People"],
  ["خياط", "Tailor", "People"],
  ["أمين صندوق", "Cashier", "People"],
  ["عامل نظافة", "Cleaner", "People"],
  ["أمين مكتبة", "Librarian", "People"],
  ["صيدلي", "Pharmacist", "People"],
  ["حارس أمن", "Security Guard", "People"],
  ["موظف استقبال", "Receptionist", "People"],
  ["خباز", "Baker", "People"],
  ["رجل توصيل", "Delivery Man", "People"],
  ["رجل أعمال", "Businessman", "People"],
  ["سيدة أعمال", "Businesswoman", "People"],
  ["مدرب", "Coach", "People"],
  ["دليل سياحي", "Tour Guide", "People"],
  ["ساحر", "Magician", "People"],
  ["راقص", "Dancer", "People"],
  ["رسام", "Painter", "People"],
  ["مبرمج", "Programmer", "People"],
  ["مصمم", "Designer", "People"],
  ["طالب", "Student", "People"],
  ["مدير مدرسة", "Principal", "People"],
  ["ملك", "King", "People"],
  ["ملكة", "Queen", "People"],
  ["أمير", "Prince", "People"],
  ["أميرة", "Princess", "People"],
  ["مهرج", "Clown", "People"],
  ["لص", "Thief", "People"],
  ["محقق", "Detective", "People"],
  ["رضيع", "Baby", "People"],
  ["رجل عجوز", "Old Man", "People"],
  ["امرأة عجوز", "Old Woman", "People"],
];

List<List<String>> emotions = [
  ["سعيد", "Happy", "Emotions"],
  ["حزين", "Sad", "Emotions"],
  ["غاضب", "Angry", "Emotions"],
  ["متحمس", "Excited", "Emotions"],
  ["مندهش", "Surprised", "Emotions"],
  ["مرتبك", "Confused", "Emotions"],
  ["متعب", "Tired", "Emotions"],
  ["يشعر بالملل", "Bored", "Emotions"],
  ["متوتر", "Nervous", "Emotions"],
  ["خجول", "Shy", "Emotions"],
  ["وحيد", "Lonely", "Emotions"],
  ["غيور", "Jealous", "Emotions"],
  ["محرج", "Embarrassed", "Emotions"],
  ["محبط", "Frustrated", "Emotions"],
  ["فخور", "Proud", "Emotions"],
  ["مفعم بالأمل", "Hopeful", "Emotions"],
  ["ممتن", "Grateful", "Emotions"],
  ["منزعج", "Annoyed", "Emotions"],
  ["هادئ", "Calm", "Emotions"],
  ["محبط", "Disappointed", "Emotions"],
  ["خائف", "Afraid", "Emotions"],
  ["راضٍ", "Satisfied", "Emotions"],
  ["حب", "Love", "Emotions"],
  ["كره", "Hate", "Emotions"],
  ["يشعر بالذنب", "Guilty", "Emotions"],
  ["يشعر بالخجل", "Ashamed", "Emotions"],
  ["يشعر بالسلام", "Peaceful", "Emotions"],
  ["فضولي", "Curious", "Emotions"],
  ["مكتئب", "Depressed", "Emotions"],
  ["مرتاح", "Relieved", "Emotions"],
  ["قلق", "Worried", "Emotions"],
  ["قنوع", "Content", "Emotions"],
  ["قلق جدًا", "Anxious", "Emotions"],
  ["حسود", "Envious", "Emotions"],
  ["مثقل بالمشاعر", "Overwhelmed", "Emotions"],
  ["مرعوب", "Terrified", "Emotions"],
  ["مسلٍ", "Amused", "Emotions"],
  ["مبتهج", "Joyful", "Emotions"],
  ["جاد", "Serious", "Emotions"],
  ["مرتاب", "Suspicious", "Emotions"],
  ["مشمئز", "Disgusted", "Emotions"],
  ["يشعر بعدم الاحترام", "Disrespected", "Emotions"],
  ["قوي", "Empowered", "Emotions"],
  ["غير واثق", "Insecure", "Emotions"],
  ["مصمم", "Determined", "Emotions"],
  ["متفائل", "Optimistic", "Emotions"],
  ["متشائم", "Pessimistic", "Emotions"],
  ["واثق بالآخرين", "Trusting", "Emotions"],
  ["معطاء", "Helpful", "Emotions"],
  ["طيب", "Kind", "Emotions"],
  ["ودود", "Friendly", "Emotions"],
  ["مرتاب", "Doubtful", "Emotions"],
  ["منفعل", "Irritated", "Emotions"],
  ["منزعج", "Upset", "Emotions"],
  ["متأثر", "Touched", "Emotions"],
  ["متأثر عاطفياً", "Moved", "Emotions"],
];

List<List<String>> technologies = [
  ["كمبيوتر", "Computer", "Technology"],
  ["لابتوب", "Laptop", "Technology"],
  ["هاتف ذكي", "Smartphone", "Technology"],
  ["جهاز لوحي", "Tablet", "Technology"],
  ["شاحن", "Charger", "Technology"],
  ["سماعات", "Headphones", "Technology"],
  ["ميكروفون", "Microphone", "Technology"],
  ["كاميرا", "Camera", "Technology"],
  ["طائرة بدون طيار", "Drone", "Technology"],
  ["ساعة ذكية", "Smartwatch", "Technology"],
  ["يو إس بي", "USB", "Technology"],
  ["قرص صلب", "Hard Drive", "Technology"],
  ["قرص الحالة الصلبة", "SSD", "Technology"],
  ["اللوحة الأم", "Motherboard", "Technology"],
  ["المعالج", "Processor", "Technology"],
  ["لوحة مفاتيح", "Keyboard", "Technology"],
  ["شاشة", "Monitor", "Technology"],
  ["طابعة", "Printer", "Technology"],
  ["ماسح ضوئي", "Scanner", "Technology"],
  ["راوتر", "Router", "Technology"],
  ["مودم", "Modem", "Technology"],
  ["واي فاي", "Wi-Fi", "Technology"],
  ["بلوتوث", "Bluetooth", "Technology"],
  ["مكبر صوت", "Speaker", "Technology"],
  ["جهاز عرض", "Projector", "Technology"],
  ["جهاز تحكم", "Remote Control", "Technology"],
  ["جهاز ألعاب", "Game Console", "Technology"],
  ["عصا تحكم", "Joystick", "Technology"],
  ["نظارة واقع افتراضي", "VR Headset", "Technology"],
  ["نظارات الواقع المعزز", "AR Glasses", "Technology"],
  ["تلفاز ذكي", "Smart TV", "Technology"],
  ["برنامج", "Software", "Technology"],
  ["تطبيق", "App", "Technology"],
  ["نظام تشغيل", "Operating System", "Technology"],
  ["متصفح", "Browser", "Technology"],
  ["موقع إلكتروني", "Website", "Technology"],
  ["سحابة", "Cloud", "Technology"],
  ["خادم", "Server", "Technology"],
  ["شبكة", "Network", "Technology"],
  ["قاعدة بيانات", "Database", "Technology"],
  ["كود", "Code", "Technology"],
  ["خوارزمية", "Algorithm", "Technology"],
  ["برمجة", "Program", "Technology"],
  ["ذكاء اصطناعي", "AI", "Technology"],
  ["تعلم الآلة", "Machine Learning", "Technology"],
  ["روبوت", "Robot", "Technology"],
  ["الأمن السيبراني", "Cybersecurity", "Technology"],
  ["جدار حماية", "Firewall", "Technology"],
  ["هاكر", "Hacker", "Technology"],
  ["خلل برمجي", "Bug", "Technology"],
  ["تحديث", "Update", "Technology"],
  ["تنزيل", "Download", "Technology"],
  ["رفع", "Upload", "Technology"],
  ["بث مباشر", "Streaming", "Technology"],
  ["بيانات", "Data", "Technology"],
  ["إشارة", "Signal", "Technology"],
  ["تكنولوجيا", "Technology", "Technology"],
  ["رقمي", "Digital", "Technology"],
  ["تماثلي", "Analog", "Technology"],
  ["قمر صناعي", "Satellite", "Technology"],
  ["مستشعر", "Sensor", "Technology"],
  ["شاشة لمس", "Touchscreen", "Technology"],
  ["التعرف على الوجه", "Facial Recognition", "Technology"],
  ["بصمة الإصبع", "Fingerprint", "Technology"],
  ["نظام تحديد المواقع", "GPS", "Technology"],
  ["اتصال قريب المدى", "NFC", "Technology"],
  ["رمز الاستجابة السريعة", "QR Code", "Technology"],
  ["طابعة ثلاثية الأبعاد", "3D Printer", "Technology"],
  ["منزل ذكي", "Smart Home", "Technology"],
  ["إضاءة ذكية", "Smart Light", "Technology"],
  ["قفل ذكي", "Smart Lock", "Technology"],
  ["ثلاجة ذكية", "Smart Fridge", "Technology"],
  ["سيارة كهربائية", "Electric Car", "Technology"],
  ["روبوت تنظيف", "Robot Vacuum", "Technology"],
  ["تشفير", "Encryption", "Technology"],
  ["محرر الأكواد", "Code Editor", "Technology"],
  ["مترجم برمجي", "Compiler", "Technology"],
  ["الطرفية", "Terminal", "Technology"],
  ["إتش تي إم إل", "HTML", "Technology"],
  ["بطارية متنقلة", "Power Bank", "Technology"],
  ["قارئ كتب إلكترونية", "E-book Reader", "Technology"],
  ["خدمة بث", "Streaming Service", "Technology"]
];

List<List<String>> art = [
  ["رسم", "Painting", "Art"],
  ["تخطيط", "Drawing", "Art"],
  ["سكتش", "Sketch", "Art"],
  ["نحت", "Sculpture", "Art"],
  ["صلصال", "Clay", "Art"],
  ["قماش رسم", "Canvas", "Art"],
  ["فرشاة", "Brush", "Art"],
  ["حامل رسم", "Easel", "Art"],
  ["لوحة الألوان", "Palette", "Art"],
  ["ألوان زيتية", "Oil Paint", "Art"],
  ["ألوان مائية", "Watercolor", "Art"],
  ["أكريليك", "Acrylic", "Art"],
  ["فحم", "Charcoal", "Art"],
  ["باستيل", "Pastel", "Art"],
  ["حبر", "Ink", "Art"],
  ["جرافيتي", "Graffiti", "Art"],
  ["فن الشارع", "Street Art", "Art"],
  ["فن رقمي", "Digital Art", "Art"],
  ["رسوم متحركة", "Animation", "Art"],
  ["رسم توضيحي", "Illustration", "Art"],
  ["كولاج", "Collage", "Art"],
  ["تصوير فوتوغرافي", "Photography", "Art"],
  ["فيلم", "Film", "Art"],
  ["مخرج", "Director", "Art"],
  ["ممثلة", "Actress", "Art"],
  ["خشبة المسرح", "Stage", "Art"],
  ["عرض مسرحي", "Performance", "Art"],
  ["مسرحية غنائية", "Musical", "Art"],
  ["أوبرا", "Opera", "Art"],
  ["باليه", "Ballet", "Art"],
  ["رقص", "Dance", "Art"],
  ["تصميم رقص", "Choreography", "Art"],
  ["زي", "Costume", "Art"],
  ["إضاءة", "Lighting", "Art"],
  ["تصميم الديكور", "Set Design", "Art"],
  ["خزف", "Ceramics", "Art"],
  ["فسيفساء", "Mosaic", "Art"],
  ["هندسة معمارية", "Architecture", "Art"],
  ["خط عربي", "Calligraphy", "Art"],
  ["تصميم", "Design", "Art"],
  ["تصميم جرافيكي", "Graphic Design", "Art"],
  ["موضة", "Fashion", "Art"],
  ["أسلوب", "Style", "Art"],
  ["معرض", "Exhibition", "Art"],
  ["صالة عرض", "Gallery", "Art"],
  ["بورتريه", "Portrait", "Art"],
  ["بورتريه ذاتي", "Self-Portrait", "Art"],
  ["طبيعة صامتة", "Still Life", "Art"],
  ["منظر طبيعي", "Landscape", "Art"],
  ["فن تجريدي", "Abstract", "Art"],
  ["فن حديث", "Modern Art", "Art"],
  ["فن كلاسيكي", "Classic Art", "Art"],
  ["تكعيبية", "Cubism", "Art"],
  ["سريالية", "Surrealism", "Art"],
  ["انطباعية", "Impressionism", "Art"]
];

List<List<String>> food = [
  ["بيتزا", "Pizza", "Food"],
  ["برجر", "Burger", "Food"],
  ["مكرونة", "Pasta", "Food"],
  ["أرز", "Rice", "Food"],
  ["دجاج", "Chicken", "Food"],
  ["لحم بقر", "Beef", "Food"],
  ["لحم غنم", "Lamb", "Food"],
  ["سمك", "Fish", "Food"],
  ["جمبري", "Shrimp", "Food"],
  ["سلطعون", "Crab", "Food"],
  ["بيض", "Eggs", "Food"],
  ["جبن", "Cheese", "Food"],
  ["حليب", "Milk", "Food"],
  ["زبادي", "Yogurt", "Food"],
  ["خبز", "Bread", "Food"],
  ["زبدة", "Butter", "Food"],
  ["مربى", "Jam", "Food"],
  ["عسل", "Honey", "Food"],
  ["ملح", "Salt", "Food"],
  ["فلفل", "Pepper", "Food"],
  ["بصل", "Onion", "Food"],
  ["ثوم", "Garlic", "Food"],
  ["طماطم", "Tomato", "Food"],
  ["بطاطس", "Potato", "Food"],
  ["جزر", "Carrot", "Food"],
  ["خيار", "Cucumber", "Food"],
  ["خس", "Lettuce", "Food"],
  ["سبانخ", "Spinach", "Food"],
  ["ذرة", "Corn", "Food"],
  ["بازلاء", "Peas", "Food"],
  ["فاصوليا", "Beans", "Food"],
  ["حمص", "Chickpeas", "Food"],
  ["عدس", "Lentils", "Food"],
  ["تفاح", "Apple", "Food"],
  ["موز", "Banana", "Food"],
  ["برتقال", "Orange", "Food"],
  ["عنب", "Grapes", "Food"],
  ["مانجو", "Mango", "Food"],
  ["بطيخ", "Watermelon", "Food"],
  ["فراولة", "Strawberry", "Food"],
  ["توت", "Blueberry", "Food"],
  ["أناناس", "Pineapple", "Food"],
  ["أفوكادو", "Avocado", "Food"],
  ["جوز هند", "Coconut", "Food"],
  ["ليمون", "Lemon", "Food"],
  ["ليمون أخضر", "Lime", "Food"],
  ["تمر", "Date", "Food"],
  ["تين", "Fig", "Food"],
  ["زيتون", "Olive", "Food"],
  ["زبيب", "Raisin", "Food"],
  ["مكسرات", "Nuts", "Food"],
  ["لوز", "Almonds", "Food"],
  ["جوز", "Walnuts", "Food"],
  ["كاجو", "Cashews", "Food"],
  ["شوكولاتة", "Chocolate", "Food"],
  ["آيس كريم", "Ice Cream", "Food"],
  ["كيك", "Cake", "Food"],
  ["كوكي", "Cookie", "Food"],
  ["دونات", "Donut", "Food"],
  ["كرواسون", "Croissant", "Food"],
  ["قهوة", "Coffee", "Food"],
  ["شاي", "Tea", "Food"],
  ["عصير", "Juice", "Food"],
  ["صودا", "Soda", "Food"],
  ["ماء", "Water", "Food"],
  ["شوربة", "Soup", "Food"],
  ["سلطة", "Salad", "Food"],
  ["سجق", "Sausage", "Food"],
  ["هوت دوج", "Hotdog", "Food"],
  ["كباب", "Kebab", "Food"],
  ["فلافل", "Falafel", "Food"],
  ["شاورما", "Shawarma", "Food"],
  ["برياني", "Biryani", "Food"],
  ["ستيك", "Steak", "Food"],
  ["تاكو", "Taco", "Food"],
  ["ناتشوز", "Nachos", "Food"],
  ["سوشي", "Sushi", "Food"],
  ["رامين", "Ramen", "Food"],
  ["كاري", "Curry", "Food"],
  ["نودلز", "Noodles", "Food"]
];

List<List<String>> tools = [
  ["مطرقة", "Hammer", "Tool"],
  ["مفك", "Screwdriver", "Tool"],
  ["مفتاح ربط", "Wrench", "Tool"],
  ["كماشة", "Pliers", "Tool"],
  ["مثقاب", "Drill", "Tool"],
  ["منشار", "Saw", "Tool"],
  ["شريط قياس", "Tape Measure", "Tool"],
  ["ميزان", "Level", "Tool"],
  ["إزميل", "Chisel", "Tool"],
  ["سكين متعددة", "Utility Knife", "Tool"],
  ["مسامير", "Screws", "Tool"],
  ["براغي", "Nails", "Tool"],
  ["صواميل", "Bolts", "Tool"],
  ["غراء", "Glue", "Tool"],
  ["فرشاة طلاء", "Paintbrush", "Tool"],
  ["آلة صنفرة", "Sander", "Tool"],
  ["سلم", "Ladder", "Tool"],
  ["عربة يدوية", "Wheelbarrow", "Tool"],
  ["مجرفة", "Shovel", "Tool"],
  ["معول", "Hoe", "Tool"],
  ["مشط زراعي", "Rake", "Tool"],
  ["فأس", "Axe", "Tool"],
  ["فأس حفر", "Pickaxe", "Tool"],
  ["عتلة", "Crowbar", "Tool"],
  ["مشابك", "Clamps", "Tool"],
  ["صندوق أدوات", "Toolbox", "Tool"],
  ["قفازات عمل", "Work Gloves", "Tool"],
  ["مصباح يدوي", "Flashlight", "Tool"],
  ["نظارات أمان", "Safety Goggles", "Tool"],
  ["قاطعة أسلاك", "Wire Cutter", "Tool"],
  ["جهاز اختبار فولت", "Voltage Tester", "Tool"],
  ["جهاز قياس متعدد", "Multimeter", "Tool"],
  ["كاوية لحام", "Soldering Iron", "Tool"],
  ["شريط لاصق", "Tape", "Tool"],
  ["مقص", "Scissors", "Tool"],
  ["آلة لحام", "Welding Machine", "Tool"],
  ["مطحنة", "Grinder", "Tool"],
  ["رأس مقبس", "Socket", "Tool"],
  ["مبرد", "File", "Tool"],
  ["ملزمة", "Vice", "Tool"],
  ["منضدة", "Bench", "Tool"],
  ["حزام أدوات", "Tool Belt", "Tool"],
  ["صينية طلاء", "Paint Tray", "Tool"],
  ["مسدس براغي", "Screw Gun", "Tool"],
  ["كاشف دعامات", "Stud Finder", "Tool"],
  ["ميزان ليزري", "Laser Level", "Tool"],
  ["قدم قياس", "Caliper", "Tool"],
  ["بوصلة", "Compass", "Tool"],
  ["مسطرين", "Trowel", "Tool"],
  ["سكين معجون", "Putty Knife", "Tool"],
  ["مسدس حراري", "Heat Gun", "Tool"],
  ["مسدس غراء ساخن", "Hot Glue Gun", "Tool"],
  ["عصا قياس", "Measuring Stick", "Tool"],
  ["دلو", "Bucket", "Tool"],
  ["مجرفة صغيرة", "Spade", "Tool"],
  ["سندان", "Anvil", "Tool"],
  ["رافعة", "Jack", "Tool"],
  ["مكبس هيدروليكي", "Hydraulic Press", "Tool"],
  ["مطرقة مطاطية", "Mallet", "Tool"],
  ["أداة تنعيم", "Deburring Tool", "Tool"],
  ["مُبَسْط", "Planer", "Tool"],
  ["مُجَوّف", "Router", "Tool"],
  ["منشار كهربائي", "Chainsaw", "Tool"],
  ["ضاغط هواء", "Air Compressor", "Tool"],
  ["رشاش طلاء", "Paint Sprayer", "Tool"],
  ["مسدس مسامير", "Nail Gun", "Tool"],
  ["مريلة", "Apron", "Tool"],
  ["مشبك", "Clamp", "Tool"],
  ["ورق صنفرة", "Sandpaper", "Tool"],
  ["رأس مثقاب", "Drill Bit", "Tool"],
  ["عتلة صغيرة", "Pry Bar", "Tool"],
  ["مسدس سيليكون", "Caulking Gun", "Tool"],
  ["كاشط طلاء", "Paint Scraper", "Tool"]
];

List<List<String>> items = [
  ["هاتف", "Phone", "Item"],
  ["كتاب", "Book", "Item"],
  ["قلم", "Pen", "Item"],
  ["قلم رصاص", "Pencil", "Item"],
  ["دفتر", "Notebook", "Item"],
  ["حقيبة", "Bag", "Item"],
  ["محفظة", "Wallet", "Item"],
  ["ساعة", "Watch", "Item"],
  ["مفتاح", "Key", "Item"],
  ["نظارات شمس", "Sunglasses", "Item"],
  ["حذاء", "Shoes", "Item"],
  ["جاكيت", "Jacket", "Item"],
  ["تيشيرت", "T-shirt", "Item"],
  ["بنطلون", "Pants", "Item"],
  ["قبعة", "Hat", "Item"],
  ["وشاح", "Scarf", "Item"],
  ["قفازات", "Gloves", "Item"],
  ["زجاجة", "Bottle", "Item"],
  ["كوب", "Cup", "Item"],
  ["مج", "Mug", "Item"],
  ["مظلة", "Umbrella", "Item"],
  ["سماعات أذن", "Earbuds", "Item"],
  ["ريموت", "Remote", "Item"],
  ["تلفاز", "Television", "Item"],
  ["فرشاة أسنان", "Toothbrush", "Item"],
  ["منشفة", "Towel", "Item"],
  ["بطانية", "Blanket", "Item"],
  ["وسادة", "Pillow", "Item"],
  ["كرسي", "Chair", "Item"],
  ["طاولة", "Table", "Item"],
  ["كنبة", "Couch", "Item"],
  ["مصباح", "Lamp", "Item"],
  ["مرآة", "Mirror", "Item"],
  ["ساعة حائط", "Clock", "Item"],
  ["مروحة", "Fan", "Item"],
  ["ثلاجة", "Fridge", "Item"],
  ["ميكروويف", "Microwave", "Item"],
  ["فرن", "Oven", "Item"],
  ["محمصة", "Toaster", "Item"],
  ["حقيبة ظهر", "Backpack", "Item"],
  ["مشط", "Comb", "Item"],
  ["مكياج", "Makeup", "Item"],
  ["عطر", "Perfume", "Item"],
  ["صابون", "Soap", "Item"],
  ["شامبو", "Shampoo", "Item"],
  ["بلسم", "Conditioner", "Item"],
  ["مزيل عرق", "Deodorant", "Item"],
  ["ملعقة", "Spoon", "Item"],
  ["شوكة", "Fork", "Item"],
  ["سكين", "Knife", "Item"],
  ["طبق", "Plate", "Item"],
  ["وعاء", "Bowl", "Item"],
  ["مسطرة", "Ruler", "Item"],
  ["آلة حاسبة", "Calculator", "Item"],
  ["تقويم", "Calendar", "Item"],
  ["فأرة", "Mouse", "Item"],
  ["فلاشة", "Flash Drive", "Item"],
  ["سبيكر", "Speaker", "Item"],
  ["ترايبود", "Tripod", "Item"],
  ["ورق دفتر", "Notebook Paper", "Item"],
  ["ملاحظات لاصقة", "Sticky Notes", "Item"],
  ["لاصق", "Glue Stick", "Item"],
  ["ممحاة", "Eraser", "Item"],
  ["قلم تمييز", "Highlighter", "Item"],
  ["ماركر", "Marker", "Item"],
  ["دباسة", "Stapler", "Item"],
  ["بطارية", "Battery", "Item"],
  ["ريموت مروحة", "Fan Remote", "Item"],
  ["يد تحكم ألعاب", "Game Controller", "Item"],
  ["خوذة", "Helmet", "Item"],
  ["قناع", "Mask", "Item"]
];
List<List<String>> otherWords = [
  ["حلم", "Dream", "Other"],
  ["ليل", "Night", "Other"],
  ["نهار", "Day", "Other"],
  ["حظ", "Luck", "Other"],
  ["ظل", "Shadow", "Other"],
  ["صمت", "Silence", "Other"],
  ["صوت", "Sound", "Other"],
  ["ضوضاء", "Noise", "Other"],
  ["همسة", "Whisper", "Other"],
  ["ضوء", "Light", "Other"],
  ["ظلام", "Darkness", "Other"],
  ["ريح", "Wind", "Other"],
  ["عاصفة", "Storm", "Other"],
  ["مطر", "Rain", "Other"],
  ["ثلج", "Snow", "Other"],
  ["نار", "Fire", "Other"],
  ["أرض", "Earth", "Other"],
  ["سماء", "Sky", "Other"],
  ["سحابة", "Cloud", "Other"],
  ["نجم", "Star", "Other"],
  ["شمس", "Sun", "Other"],
  ["قمر", "Moon", "Other"],
  ["وقت", "Time", "Other"],
  ["ذاكرة", "Memory", "Other"],
  ["أمل", "Hope", "Other"],
  ["خوف", "Fear", "Other"],
  ["فرح", "Joy", "Other"],
  ["مفاجأة", "Surprise", "Other"],
  ["سر", "Secret", "Other"],
  ["سحر", "Magic", "Other"],
  ["قوة", "Power", "Other"],
  ["سلام", "Peace", "Other"],
  ["حرب", "War", "Other"],
  ["طاقة", "Energy", "Other"],
  ["صداقة", "Friendship", "Other"],
  ["قدر", "Destiny", "Other"],
  ["مصير", "Fate", "Other"],
  ["حقيقة", "Truth", "Other"],
  ["كذبة", "Lie", "Other"],
  ["هدية", "Gift", "Other"],
  ["لعنة", "Curse", "Other"],
  ["رحلة", "Journey", "Other"],
  ["طريق", "Path", "Other"],
  ["خيار", "Choice", "Other"],
  ["حرية", "Freedom", "Other"],
  ["سجن", "Prison", "Other"],
  ["أمنية", "Wish", "Other"],
  ["لعبة", "Game", "Other"],
  ["فرصة", "Chance", "Other"],
  ["عملة", "Coin", "Other"],
  ["وميض", "Flash", "Other"],
  ["فخ", "Trap", "Other"],
  ["لغز", "Puzzle", "Other"],
  ["كلمة السر", "PassWord", "Other"],
  ["خريطة", "Map", "Other"],
  ["منطقة", "Area", "Other"],
  ["ابتكار", "Innovation", "Other"],
  ["تطوير", "Development", "Other"],
  ["تحدي", "Challenge", "Other"],
  ["مشكلة", "Problem", "Other"],
  ["حل", "Solution", "Other"],
  ["خيال", "Imagination", "Other"],
  ["أفكار", "Ideas", "Other"],
  ["اكتشاف", "Discovery", "Other"],
  ["مستقبل", "Future", "Other"],
  ["ماضي", "Past", "Other"],
  ["حاجة", "Need", "Other"],
  ["ضرورة", "Requirement", "Other"],
  ["مهم", "Important", "Other"],
  ["مهمة", "Task", "Other"],
  ["تحويل", "Transformation", "Other"],
  ["إلهام", "Inspiration", "Other"], 
  
];


Future<void> intiateWords() async {
  final FirebaseFirestore firestore = GetIt.instance.get<FirebaseFirestore>();
  final CollectionReference words = firestore.collection('allWords');
  places.shuffle();
  people.shuffle();
  emotions.shuffle();
  technologies.shuffle();
  art.shuffle();
  otherWords.shuffle();
  tools.shuffle();
  items.shuffle();
  food.shuffle();
  // Combine all categories into a map: category name → word list
  final Map<String, List<List<String>>> categorizedWords = {
    'Places': places,
    'People': people,
    'Emotions': emotions,
    'Technologies': technologies,
    'Art': art,
    'Other': otherWords,
    'Tools': tools,
    'Items': items,
    'Food': food,
  };

  try {
    for (var entry in categorizedWords.entries) {
      final String category = entry.key;
      final List<List<String>> wordList = entry.value;

      final DocumentReference categoryDoc = words.doc(category);
      

     

      final CollectionReference subcollection = categoryDoc.collection('categoryWords');

      WriteBatch batch = firestore.batch();

      for (int i = 0; i < wordList.length; i++) {
        final wordData = {
          'ArabicWord': wordList[i][0],
          'EnglishWord': wordList[i][1],
          'category': wordList[i][2],
          'index': i
        };

        final docRef = subcollection.doc(i.toString());
        batch.set(docRef, wordData);
      }

      await batch.commit();
    }

    print('Successfully inserted all categorized words into Firestore');
  } catch (e) {
    print('Error inserting words: $e');
  }
}

// Future<void> intiateWords() async {
//   final FirebaseFirestore firestore = GetIt.instance.get<FirebaseFirestore>();
//   final CollectionReference words = firestore.collection('words');
//   // Helper function to insert words from a list
//   int index=0;

//   Future<void> insertWordList(List<List<String> > allWords) async {
//     // Insert English words
//     for (int i=0;i<allWords.length;i++) {
//       await words.add({
//         'EnglishWord': allWords[i][1],
//         'ArabicWord': allWords[i][0],      
//         'category': allWords[i][2],
//         'index':index
//       });
//       index++;
//     }
//   }

//   // Insert all word categories
//   try {
//     List<List<String>> allWords=[];
//     allWords.addAll(places);
//     allWords.addAll(people);
//     allWords.addAll(emotions);
//     allWords.addAll(technologies);
//     allWords.addAll(art);
//     allWords.addAll(otherWords);
//     allWords.addAll(tools);
//     allWords.addAll(items);
//     allWords.addAll(food);
//     allWords.shuffle();
//     await insertWordList(allWords);
    
//     // ignore: avoid_print
//     print('Successfully inserted all words into Firestore');
//   } catch (e) {
//     // ignore: avoid_print
//     print('Error inserting words: $e');
//   }
// } 



Future<void> insertNewLanguage(
  List<String> englishList,
  List<String> newLanguageList,
  String newLanguage,
  String category,
) async {
  final FirebaseFirestore firestore = GetIt.instance.get<FirebaseFirestore>();
  final CollectionReference subcollection =
      firestore.collection('allWords').doc(category).collection('categoryWords');

  for (int i = 0; i < englishList.length; i++) {
    final querySnapshot = await subcollection
        .where('EnglishWord', isEqualTo: englishList[i])
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final docRef = querySnapshot.docs.first.reference;

      await docRef.update({
        newLanguage: newLanguageList[i],
      });
    } else {
      print('English word "${englishList[i]}" not found in category "$category"');
    }
  }

  print('Finished updating documents with new language "$newLanguage" in category "$category"');
}



Future<void> insertMultipleLanguages(Map<String, List<String>> newWords, String category) async {
  // newWords example:
  // {EnglishWord: [test1, test2], ArabicWord: [تست1, تست2]}
  
  final FirebaseFirestore firestore = GetIt.instance.get<FirebaseFirestore>();
  final CollectionReference mainCollection = firestore.collection('allWords');
  final DocumentReference categoryDoc = mainCollection.doc(category);
  final CollectionReference subcollection = categoryDoc.collection('categoryWords');



  // Get last index in subcollection
  int lastIndex = 0;
  final querySnapshot = await subcollection.orderBy('index', descending: true).limit(1).get();
  if (querySnapshot.docs.isNotEmpty) {
    lastIndex = querySnapshot.docs.first['index'] + 1;
  }

  // Prepare batch write
  WriteBatch batch = firestore.batch();

  for (int i = 0; i < newWords.values.first.length; i++) {
    final Map<String, dynamic> wordData = {
      'category': category,
      'index': lastIndex,
    };

    // Fill in all languages
    for (final String language in newWords.keys) {
      wordData[language] = newWords[language]![i];
    }

    final DocumentReference wordDoc = subcollection.doc(lastIndex.toString());
    batch.set(wordDoc, wordData);

    lastIndex++;
  }

  // Commit batch
  try {
    await batch.commit();
    print('Words successfully added to category "$category".');
  } catch (e) {
    print('Error inserting multiple languages: $e');
  }
}

}