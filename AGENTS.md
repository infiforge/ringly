---
applyTo: "services/internal/callattribution/**/*"
---

# CallAttribution AI Agent Guide

## Service Overview

**Name:** CallAttribution  
**Description:** Self-hosted call attribution system for Google Ads campaigns targeting Kenya and African markets. Tracks offline conversions from phone calls by attributing them to specific ad campaigns.  
**Location:** `services/internal/callattribution/`  
**Type:** Full-stack application with backend API, cross-platform frontend, and phone tracking component

## Architecture

CallAttribution is organized as an Nx monorepo with four main components:

```
callattribution/
├── backend/          # Deno API server
│   ├── server.ts     # Main server entry point
│   ├── routes/       # API route handlers
│   └── services/     # Business logic services
├── frontend/         # Flutter cross-platform app
│   ├── lib/          # Dart source code
│   │   ├── main.dart
│   │   ├── pages/
│   │   └── services/
│   └── pubspec.yaml
├── tracker/          # Phone call tracking component
│   └── [tracking files]
└── docker/           # Docker deployment configs
```

## Backend Details

### Technology Stack
- **Runtime:** Deno (TypeScript)
- **Web Framework:** Oak or Hono
- **Database:** MongoDB
- **Authentication:** JWT
- **External APIs:** Google Ads API (offline conversions)

### Key Dependencies
```typescript
// Oak/Hono web framework
// MongoDB driver
// JWT handling (djwt)
// Google Ads API client
// SMS/WhatsApp gateway integration
```

### Entry Points
- **Main Server:** `backend/server.ts`
- **API Routes:** `backend/routes/` (campaigns, calls, attributions, reports)

### Database (MongoDB)
- Campaign configurations
- Phone number mappings
- Call logs with GCLID attribution
- Conversion events
- Agency/client accounts (multi-tenant)

## Frontend Details

### Technology Stack
- **Framework:** Flutter (Dart)
- **Multi-platform:** Android, iOS, Web, Desktop
- **State Management:** Provider
- **HTTP Client:** http package

### Key Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.5          # State management
  http: ^1.1.0              # API calls
  fl_chart: ^0.68.0         # Analytics charts
  intl: ^0.18.0             # Date formatting
```

### Entry Points
- **Main App:** `frontend/lib/main.dart`
- **Dashboard:** Campaign and call analytics
- **Reports:** Conversion tracking and ROI

## Key Features

### GCLID Tracking and Attribution
- Capture Google Click ID (GCLID) from ad clicks
- Store GCLID with phone number mappings
- Attribute calls to specific campaigns
- Conversion window handling (typically 30-90 days)

### DTMF/IVR Integration
- Interactive Voice Response for call routing
- DTMF (touch-tone) input collection
- Press-1-for-sales, Press-2-for-support patterns
- Dynamic number insertion (DNI)

### Offline Conversion Tracking
- Send conversions to Google Ads API
- Conversion value and currency handling
- Conversion time and adjustment (if needed)
- Offline conversion import schedule

### SMS/WhatsApp Notifications
- Real-time call alerts to agencies/clients
- Daily/weekly summary reports
- Missed call notifications
- Conversion confirmations

### Multi-tenant for Agencies
- Agency account management
- Client sub-accounts
- Role-based access (admin, manager, viewer)
- White-labeling support

### Call Analytics Dashboard
- Real-time call volume
- Conversion rates by campaign
- Cost per call/conversion
- Call duration and quality metrics
- Geographic call distribution

## Development Workflow

### Standard Commands
```bash
# Navigate to service
cd services/internal/callattribution

# Backend development
nx run backend:serve        # Development
deno run --allow-all backend/server.ts  # Direct Deno

# Frontend development
nx run frontend:serve       # Development
flutter run                 # Direct Flutter

# Full stack
nx run serve               # Both services
nx run build               # Build all

# Docker deployment
docker-compose up          # If using Docker
```

## Google Ads Integration

### Offline Conversion Import
```typescript
// Google Ads API integration
// Conversion action creation
// Click-to-call conversion upload
// Conversion adjustment (if needed)
```

### Required Setup
1. Google Ads API access
2. Developer token
3. OAuth credentials
4. Conversion action configuration
5. GCLID auto-tagging enabled

### Conversion Upload
- Scheduled uploads (hourly/daily)
- Click identifier (GCLID) association
- Conversion timestamp
- Conversion value
- Currency code

## Phone Number Management

### Dynamic Number Insertion (DNI)
- Replace phone numbers on client websites
- Different numbers per campaign/source
- JavaScript snippet for websites
- Session-based number assignment

### Number Pools
- Local Kenyan numbers
- Toll-free options
- Number rotation for high volume
- Geographic number allocation

### Call Routing
- IVR menus (Press 1, Press 2)
- Time-based routing
- Department/location routing
- Voicemail and callbacks

## African Market Considerations

### Kenya-Specific
- Local phone number format (+254)
- Mpesa integration (for payments if applicable)
- SMS gateway providers (Twilio, Africa's Talking)
- Timezone: Africa/Nairobi (EAT)

### Connectivity
- Handle intermittent connectivity
- Offline queue for conversions
- Retry logic for API calls
- Graceful degradation

### Regulatory
- Data privacy compliance (Kenya Data Protection Act)
- Call recording consent (if implemented)
- Telecommunications regulations

## Security & Privacy

### Call Data Protection
- **NEVER** expose call recordings without consent
- Encrypt call metadata
- Secure GCLID handling
- Access logging

### Google Ads Security
- OAuth token rotation
- API key protection
- Conversion data validation
- Rate limiting compliance

### Multi-tenant Isolation
- Agency data separation
- Client access controls
- No cross-tenant data leakage

## Testing

### Backend
- GCLID attribution logic tests
- Google Ads API integration tests
- Call tracking webhook tests
- MongoDB query tests

### Frontend
- Dashboard widget tests
- Report generation tests
- Real-time update tests

### Integration
- End-to-end call flow testing
- Google Ads conversion verification
- SMS delivery testing

## Common Tasks

### Adding a New Campaign
1. Create campaign in backend
2. Allocate phone numbers
3. Generate tracking code/snippet
4. Configure conversion action in Google Ads
5. Test attribution flow

### Setting Up DNI (Dynamic Number Insertion)
1. Generate JavaScript snippet
2. Client installs on website
3. Configure number pools
4. Test number replacement
5. Verify GCLID capture

### Debugging Attribution
1. Check GCLID capture in logs
2. Verify phone number assignment
3. Confirm call event recording
4. Validate Google Ads conversion upload
5. Check for time zone issues

## Important Notes

1. **Always** test GCLID attribution thoroughly
2. **Never** send duplicate conversions to Google Ads
3. **Always** handle timezone conversions correctly (EAT to UTC)
4. **Always** implement retry logic for Google Ads API
5. **Never** hardcode Google Ads credentials
6. **Always** log conversion uploads for audit
7. **Monitor** Google Ads API rate limits

## Security Checklist

- [ ] Google Ads API credentials secured
- [ ] OAuth token rotation implemented
- [ ] Call data encrypted at rest
- [ ] Multi-tenant data isolation
- [ ] GCLID handling secure
- [ ] API rate limiting respected
- [ ] HTTPS/WSS only
- [ ] Access logging enabled
- [ ] No duplicate conversions
- [ ] Timezone handling verified
