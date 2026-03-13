# Ringly Call Attribution System (CAS) - Workplan

## Project Overview
Building a high-end Call Attribution System for Google Ads campaigns targeting Kenya and African markets. The system tracks offline conversions from phone calls by attributing them to specific ad campaigns using GCLID (Google Click Identifier).

---

## Phase 1: Foundation & Architecture

### Step 1.1: Project Structure Setup ✅
- [x] Analyze existing codebase structure
- [x] Review existing dependencies and packages
- [x] Identify required additional packages

### Step 1.2: Theme & Design System
- [ ] Create comprehensive theme configuration
  - [ ] Define color palette (based on image: dark green sidebar #1B2B27, light backgrounds, accent colors)
  - [ ] Set up dark/light mode themes
  - [ ] Create typography styles
  - [ ] Define spacing and layout constants
- [ ] Create shared UI components
  - [ ] Sidebar navigation component
  - [ ] App bar/header component
  - [ ] Card components
  - [ ] Badge components (Qualified, Sale, Spam)
  - [ ] Data table component
  - [ ] Filter chips/tabs

### Step 1.3: Data Models
- [ ] Create core data models
  - [ ] Call model (id, type, contact, phone, city, duration, quality, campaign, gclid, timestamp)
  - [ ] Campaign model (id, name, source, status, budget, numbers)
  - [ ] Contact model (id, name, phone, email, city, history)
  - [ ] User/Agency model (id, name, settings, permissions)
  - [ ] Number pool model (id, number, type, assignedCampaign)

---

## Phase 2: Core UI Implementation

### Step 2.1: App Shell & Navigation
- [ ] Create main app shell with sidebar
  - [ ] Implement responsive sidebar (collapsible on mobile)
  - [ ] Navigation items: Dashboard, Call Log, WhatsApp, UTM Builder, Tracking Setup, GA4 Guide, Settings
  - [ ] Active state highlighting
  - [ ] User profile section
  - [ ] App branding (Ringly)

### Step 2.2: Dashboard Screen
- [ ] Create Dashboard page
  - [ ] Summary cards (Total Calls, Conversion Rate, Active Campaigns, Revenue)
  - [ ] Call volume chart (last 30 days)
  - [ ] Recent calls widget
  - [ ] Campaign performance widget
  - [ ] Quick actions section

### Step 2.3: Call Log Screen (Primary)
- [ ] Create Call Log page matching image
  - [ ] Header with title "Call Log" and subtitle
  - [ ] Date range filter (Last 30 days dropdown)
  - [ ] Search bar functionality
  - [ ] Filter tabs: All, Calls, WhatsApp
  - [ ] Data table with columns:
    - Type (phone/chat icon)
    - Contact (name + phone number)
    - City
    - Duration
    - Quality (badges: Qualified, Sale, Spam)
    - Campaign
    - GCLID
  - [ ] Pagination or infinite scroll
  - [ ] Export functionality

### Step 2.4: WhatsApp Screen
- [ ] Create WhatsApp integration page
  - [ ] WhatsApp message log table
  - [ ] Message templates management
  - [ ] Conversation view
  - [ ] Send message interface

### Step 2.5: UTM Builder Screen
- [ ] Create UTM parameter builder
  - [ ] Campaign URL input
  - [ ] UTM source, medium, campaign, term, content fields
  - [ ] Generated URL preview
  - [ ] Copy to clipboard
  - [ ] Saved UTM links list

### Step 2.6: Tracking Setup Screen
- [ ] Create tracking configuration page
  - [ ] Dynamic Number Insertion (DNI) setup
  - [ ] Website integration code snippet
  - [ ] Number pool management
  - [ ] GCLID capture verification
  - [ ] Domain configuration

### Step 2.7: GA4 Guide Screen
- [ ] Create Google Analytics 4 integration guide
  - [ ] Step-by-step setup instructions
  - [ ] Event tracking configuration
  - [ ] Conversion tracking setup
  - [ ] Testing verification

### Step 2.8: Settings Screen
- [ ] Create settings page
  - [ ] User profile management
  - [ ] Agency settings (multi-tenant)
  - [ ] Notification preferences
  - [ ] Integration settings (Google Ads, GA4)
  - [ ] Billing/subscription info
  - [ ] Dark/light mode toggle

---

## Phase 3: State Management & Services

### Step 3.1: State Management Setup
- [ ] Create Riverpod providers
  - [ ] Theme provider (dark/light mode)
  - [ ] Navigation state provider
  - [ ] Call data provider
  - [ ] Campaign data provider
  - [ ] Filter/search state provider

### Step 3.2: Mock Data Services
- [ ] Create mock data generators
  - [ ] Generate sample calls (Kenyan numbers +254)
  - [ ] Generate sample campaigns
  - [ ] Generate sample contacts
  - [ ] Mock GCLID values
- [ ] Create API service interfaces
  - [ ] CallService (getCalls, filterCalls, exportCalls)
  - [ ] CampaignService (getCampaigns, createCampaign, updateCampaign)
  - [ ] ContactService (getContacts, createContact)

---

## Phase 4: Advanced Features

### Step 4.1: Responsive Design
- [ ] Mobile responsiveness
  - [ ] Sidebar becomes drawer on mobile
  - [ ] Data tables become cards on small screens
  - [ ] Touch-friendly controls
- [ ] Tablet responsiveness
  - [ ] Collapsible sidebar
  - [ ] Adaptive layouts

### Step 4.2: Dark/Light Mode
- [ ] Implement theme switching
  - [ ] Persist user preference
  - [ ] System theme detection
  - [ ] Smooth transitions

### Step 4.3: Charts & Analytics
- [ ] Add chart widgets
  - [ ] Call volume over time (line chart)
  - [ ] Call quality distribution (pie chart)
  - [ ] Campaign performance (bar chart)
  - [ ] Geographic distribution (map or chart)

### Step 4.4: Search & Filtering
- [ ] Implement advanced search
  - [ ] Full-text search across calls
  - [ ] Filter by date range
  - [ ] Filter by campaign
  - [ ] Filter by quality/status
  - [ ] Filter by city

---

## Phase 5: Backend Integration (Future)

### Step 5.1: API Integration
- [ ] Connect to Deno backend
  - [ ] REST API client setup
  - [ ] Authentication integration
  - [ ] Error handling

### Step 5.2: Real-time Updates
- [ ] WebSocket integration
  - [ ] Live call notifications
  - [ ] Real-time dashboard updates

---

## Implementation Order

1. **Start with Phase 1.2** - Theme system (foundation for all UI)
2. **Phase 1.3** - Data models (needed for all screens)
3. **Phase 2.1** - App shell (framework for all pages)
4. **Phase 3.1** - State management (needed for interactivity)
5. **Phase 3.2** - Mock data (enables UI development)
6. **Phase 2.2-2.8** - All screens (in parallel where possible)
7. **Phase 4** - Polish and advanced features

---

## Color Palette (from image analysis)

**Primary Colors:**
- Sidebar background: #1B2B27 (dark green)
- Sidebar text: #FFFFFF (white)
- Active nav item: #2A3F3A (slightly lighter green)
- App accent: #4ADE80 (green for badges/icons)

**Backgrounds:**
- Main background: #F8FAFC (very light gray)
- Card background: #FFFFFF (white)
- Table header: #F1F5F9 (light gray)

**Text:**
- Primary text: #1E293B (dark slate)
- Secondary text: #64748B (gray)
- Subtitle: #94A3B8 (light gray)

**Status Badges:**
- Qualified: #DCFCE7 (light green bg), #166534 (green text)
- Sale: #FEF3C7 (light yellow bg), #92400E (amber text)
- Spam: #FEE2E2 (light red bg), #991B1B (red text)

**Icons:**
- Call icon: #4ADE80 (green)
- WhatsApp icon: #25D366 (WhatsApp green)

---

## Dependencies to Add

```yaml
dependencies:
  # Already present:
  # - fl_chart: ^0.66.0
  # - data_table_2: ^2.5.9
  # - intl: ^0.19.0
  
  # May need:
  # - responsive_framework: ^1.1.1 (for responsive design)
  # - flutter_screenutil: ^5.9.0 (optional, for screen adaptation)
```

---

## Notes

- All screens must be responsive (mobile, tablet, desktop)
- All screens must support dark/light mode
- Use Kenyan phone number format (+254) in mock data
- GCLID format: gclid=EAia... (Google Click Identifier)
- Campaign naming: location_category_month (e.g., nairobi_realestate_q1)
