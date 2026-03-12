# CallAttribution

Self-hosted call attribution system for Google Ads campaigns targeting Kenya and African markets. Tracks offline conversions from phone calls by attributing them to specific ad campaigns.

## Features

- **GCLID Tracking**: Capture Google Click IDs from ad clicks
- **Dynamic Number Display**: Automatically display unique phone numbers per visitor
- **DTMF/IVR Integration**: Interactive Voice Response with touch-tone input collection
- **Offline Conversion Tracking**: Upload conversions to Google Ads API
- **Multi-tenancy**: Support for agencies with multiple client accounts
- **Real-time Dashboard**: Call analytics and conversion metrics
- **SMS/WhatsApp Notifications**: Instant alerts and reports

## Architecture

```
callattribution/
├── backend/          # Deno API server
│   ├── server.ts     # Main server entry point
│   ├── routes/       # API route handlers
│   └── services/     # Business logic services
├── frontend/         # Flutter cross-platform app
│   ├── lib/          # Dart source code
│   └── pubspec.yaml
├── tracker/          # JavaScript tracking library
│   └── src/          # Session capture & DND
└── docker/           # Docker deployment configs
```

## Technology Stack

- **Backend**: Deno (TypeScript) + Hono + MongoDB + Redis
- **Frontend**: Flutter (Dart) - Android, iOS, Web, Desktop
- **Tracker**: TypeScript + Rollup - Session capture & DND

## Quick Start

### Prerequisites

- Deno 1.40+
- Flutter 3.16+
- Node.js 18+ (for tracker build)
- MongoDB 6.0+
- Redis 7.0+

### Installation

```bash
cd services/internal/callattribution

# Install dependencies
npm install

# Backend - copy environment variables
cp backend/.env.example backend/.env
# Edit backend/.env with your configuration

# Start backend
cd backend
deno task serve

# Frontend
cd frontend
flutter pub get
flutter run

# Tracker (build for distribution)
cd tracker
npm install
npm run build
```

### Docker Deployment

```bash
cd docker
docker-compose up -d
```

## Google Ads Integration

1. **Enable Auto-tagging**: Settings > Account Settings > Auto-tagging = ON
2. **Create Conversion Action**: Tools & Settings > Conversions > Import from clicks
3. **Configure API Access**: Obtain Developer Token from Google Ads API Center
4. **Set Environment Variables**: Add credentials to `.env`

See [docs/google-ads-integration.md](docs/google-ads-integration.md) for detailed setup.

## License

UNLICENSED - Proprietary software
