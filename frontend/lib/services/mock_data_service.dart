import 'dart:math';
import '../models/call_models.dart';

class MockDataService {
  static final Random _random = Random();
  
  // Kenyan cities
  static const List<String> kenyanCities = [
    'Nairobi',
    'Mombasa',
    'Kisumu',
    'Nakuru',
    'Eldoret',
    'Thika',
    'Malindi',
    'Kitale',
    'Naivasha',
    'Machakos',
  ];

  // Sample campaign names
  static const List<Map<String, String>> campaigns = [
    {'id': 'camp_001', 'name': 'nairobi_realestate_q1', 'source': 'google/cpc'},
    {'id': 'camp_002', 'name': 'mombasa_tours_feb', 'source': 'google/cpc'},
    {'id': 'camp_003', 'name': 'kisumu_plumbing', 'source': 'google/cpc'},
    {'id': 'camp_004', 'name': 'nairobi_healthcare', 'source': 'google/cpc'},
    {'id': 'camp_005', 'name': 'eldoret_agriculture', 'source': 'google/cpc'},
    {'id': 'camp_006', 'name': 'nakuru_automotive', 'source': 'google/cpc'},
  ];

  // Sample first names
  static const List<String> firstNames = [
    'James', 'Mary', 'John', 'Grace', 'Peter', 'Sarah', 'Michael', 'Jane',
    'David', 'Elizabeth', 'Joseph', 'Agnes', 'Daniel', 'Lucy', 'Paul', 'Ann',
    'Samuel', 'Joyce', 'George', 'Esther', 'Stephen', 'Ruth', 'Patrick', 'Mercy',
    'Francis', 'Catherine', 'Alex', 'Lilian', 'Eric', 'Christine', 'Mwangi', 'Kamau',
    'Odhiambo', 'Ochieng', 'Mutua', 'Kipchoge', 'Wanjiru', 'Amina', 'Hassan', 'Abdi',
  ];

  // Sample last names
  static const List<String> lastNames = [
    'Mwangi', 'Kamau', 'Odhiambo', 'Ochieng', 'Mutua', 'Kipchoge', 'Wanjiru',
    'Achieng', 'Kariuki', 'Njoroge', 'Kimani', 'Wafula', 'Omondi', 'Owino',
    'Maina', 'Kamau', 'Kibet', 'Langat', 'Ruto', 'Moi', 'Kenyatta', 'Odinga',
    'Mudavadi', 'Wetangula', 'Khalwale', 'Atwoli', 'Gachagua', 'Karua',
  ];

  // Generate a Kenyan phone number
  static String _generateKenyanPhoneNumber() {
    final prefixes = ['712', '713', '714', '715', '716', '717', '718', '719',
                      '720', '721', '722', '723', '724', '725', '726', '727',
                      '728', '729', '790', '791', '792', '793', '794', '795',
                      '796', '797', '798', '799', '700', '701', '702', '703',
                      '704', '705', '706', '707', '708', '709',
                      '740', '741', '742', '743', '745', '746', '747', '748', '749',
                      '750', '751', '752', '753', '754', '755', '756', '757', '758', '759',
                      '768', '769', '780', '781', '782', '783', '784', '785', '786', '787', '788', '789',
                      '110', '111', '112', '113', '114', '115', '116', '117', '118', '119'];
    
    final prefix = prefixes[_random.nextInt(prefixes.length)];
    final suffix = _random.nextInt(1000000).toString().padLeft(6, '0');
    return '+254 $prefix $suffix';
  }

  // Generate GCLID
  static String _generateGclid() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final buffer = StringBuffer('EAia');
    for (int i = 0; i < 20; i++) {
      buffer.write(chars[_random.nextInt(chars.length)]);
    }
    return buffer.toString();
  }

  // Generate random name
  static String _generateName() {
    return '${firstNames[_random.nextInt(firstNames.length)]} ${lastNames[_random.nextInt(lastNames.length)]}';
  }

  // Generate random duration
  static String _generateDuration() {
    final minutes = _random.nextInt(10);
    final seconds = _random.nextInt(60);
    if (minutes == 0) {
      return '${seconds.toString().padLeft(2, '0')}';
    }
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  // Generate random quality
  static CallQuality _generateQuality() {
    final qualities = [
      CallQuality.qualified,
      CallQuality.sale,
      CallQuality.spam,
      CallQuality.new_lead,
      CallQuality.followUp,
    ];
    final weights = [0.35, 0.15, 0.15, 0.25, 0.10];
    
    final random = _random.nextDouble();
    double cumulativeWeight = 0;
    
    for (int i = 0; i < qualities.length; i++) {
      cumulativeWeight += weights[i];
      if (random <= cumulativeWeight) {
        return qualities[i];
      }
    }
    return CallQuality.qualified;
  }

  // Generate mock calls
  static List<Call> generateMockCalls({int count = 50}) {
    final calls = <Call>[];
    final now = DateTime.now();

    for (int i = 0; i < count; i++) {
      final campaign = campaigns[_random.nextInt(campaigns.length)];
      final isWhatsApp = _random.nextBool() && _random.nextBool(); // 25% WhatsApp
      final city = kenyanCities[_random.nextInt(kenyanCities.length)];
      final quality = _generateQuality();
      
      // Generate timestamp within last 30 days
      final daysAgo = _random.nextInt(30);
      final hoursAgo = _random.nextInt(24);
      final timestamp = now.subtract(Duration(days: daysAgo, hours: hoursAgo));

      calls.add(Call(
        id: 'call_${i.toString().padLeft(4, '0')}',
        type: isWhatsApp ? CallType.whatsapp : CallType.phone,
        contactName: _generateName(),
        phoneNumber: _generateKenyanPhoneNumber(),
        city: city,
        duration: isWhatsApp ? null : _generateDuration(),
        quality: quality,
        campaignId: campaign['id']!,
        campaignName: campaign['name']!,
        gclid: _generateGclid(),
        timestamp: timestamp,
        source: campaign['source'],
        medium: 'cpc',
      ));
    }

    // Sort by timestamp descending
    calls.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return calls;
  }

  // Generate mock campaigns
  static List<Campaign> generateMockCampaigns() {
    final now = DateTime.now();
    
    return campaigns.map((camp) {
      final statusValues = CampaignStatus.values;
      return Campaign(
        id: camp['id']!,
        name: camp['name']!,
        source: 'Google Ads',
        medium: 'cpc',
        description: 'Campaign for ${camp['name']!.split('_')[1]}',
        status: statusValues[_random.nextInt(statusValues.length)],
        budget: 50000 + _random.nextInt(200000).toDouble(),
        startDate: now.subtract(Duration(days: _random.nextInt(60))),
        endDate: now.add(Duration(days: _random.nextInt(90))),
        createdAt: now.subtract(Duration(days: _random.nextInt(90))),
        updatedAt: now.subtract(Duration(days: _random.nextInt(30))),
      );
    }).toList();
  }

  // Generate mock contacts
  static List<Contact> generateMockContacts({int count = 30}) {
    final contacts = <Contact>[];
    final now = DateTime.now();

    for (int i = 0; i < count; i++) {
      final city = kenyanCities[_random.nextInt(kenyanCities.length)];
      contacts.add(Contact(
        id: 'contact_${i.toString().padLeft(4, '0')}',
        name: _generateName(),
        phoneNumber: _generateKenyanPhoneNumber(),
        email: 'user$i@example.com',
        city: city,
        country: 'Kenya',
        totalCalls: _random.nextInt(10) + 1,
        totalConversions: _random.nextInt(3),
        createdAt: now.subtract(Duration(days: _random.nextInt(180))),
        updatedAt: now.subtract(Duration(days: _random.nextInt(30))),
      ));
    }

    return contacts;
  }

  // Generate mock number pools
  static List<NumberPool> generateMockNumberPools({int count = 20}) {
    final numbers = <NumberPool>[];
    
    for (int i = 0; i < count; i++) {
      final isAssigned = _random.nextBool();
      final assignedCampaign = isAssigned ? campaigns[_random.nextInt(campaigns.length)] : null;
      
      numbers.add(NumberPool(
        id: 'num_${i.toString().padLeft(4, '0')}',
        phoneNumber: _generateKenyanPhoneNumber(),
        type: NumberType.mobile,
        city: kenyanCities[_random.nextInt(kenyanCities.length)],
        assignedCampaignId: assignedCampaign?['id'],
        assignedCampaignName: assignedCampaign?['name'],
        status: isAssigned ? NumberStatus.assigned : NumberStatus.active,
      ));
    }

    return numbers;
  }

  // Generate mock WhatsApp messages
  static List<WhatsAppMessage> generateMockWhatsAppMessages({int count = 30}) {
    final messages = <WhatsAppMessage>[];
    final now = DateTime.now();

    for (int i = 0; i < count; i++) {
      final isInbound = _random.nextBool();
      final daysAgo = _random.nextInt(30);
      
      messages.add(WhatsAppMessage(
        id: 'msg_${i.toString().padLeft(4, '0')}',
        contactName: _generateName(),
        phoneNumber: _generateKenyanPhoneNumber(),
        message: isInbound 
            ? 'Hello, I saw your ad and I\'m interested in your services. Can we schedule a call?'
            : 'Thank you for reaching out! I\'d be happy to help. When would be a good time to chat?',
        direction: isInbound ? MessageDirection.inbound : MessageDirection.outbound,
        status: MessageStatus.values[_random.nextInt(MessageStatus.values.length)],
        timestamp: now.subtract(Duration(days: daysAgo, minutes: _random.nextInt(1440))),
        gclid: _generateGclid(),
      ));
    }

    messages.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return messages;
  }
}
