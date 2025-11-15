+++
title = "Integration Guide"
description = "Integrate ThreatLvl Games with other tools and platforms"
weight = 2
+++

# Integration Guide

Learn how to integrate ThreatLvl Games with other tools and platforms to enhance your gaming experience.

## Virtual Tabletop Platforms

### Roll20 Integration

#### Character Import

Import characters from Roll20:

1. Export character from Roll20 as JSON
2. Go to Character Builder → Import
3. Select "Roll20 Format"
4. Upload JSON file

#### API Bridge

Use our Roll20 API scripts:

```javascript
// Add to Roll20 API scripts
!threatlvl-sync character --name="Character Name"
```

Features:
- Sync character stats
- Share initiative to Roll20
- Roll dice in both platforms

### Foundry VTT Integration

#### Module Installation

1. Open Foundry VTT
2. Go to Add-on Modules
3. Search "ThreatLvl Games"
4. Install and activate

#### Configuration

```javascript
// In Foundry module settings
{
  "apiKey": "your-api-key-here",
  "syncCharacters": true,
  "syncInitiative": true,
  "syncSpells": true
}
```

#### Features

- **Character Sync**: Two-way character synchronization
- **Initiative Sync**: Share initiative tracker
- **Spell Tracking**: Sync spell slots and usage
- **API Integration**: Full API access

### D&D Beyond

#### Character Import

Import from D&D Beyond:

1. Use D&D Beyond character sheet URL
2. Click "Import from D&D Beyond"
3. Authenticate (if required)
4. Select character to import

> **Note**: D&D Beyond imports require their API access. Some features may be limited based on your D&D Beyond subscription.

## Discord Integration

### Discord Bot

Add ThreatLvl Bot to your server:

#### Setup

1. Visit [bot.threatlvl.games](https://bot.threatlvl.games)
2. Click "Add to Discord"
3. Select your server
4. Authorize permissions

#### Commands

```
/roll [dice] - Roll dice
/character [name] - View character sheet
/initiative start - Start initiative tracker
/spell [name] - Look up spell
/monster [name] - Look up monster stats
```

#### Examples

```
/roll 1d20+5
/character Gandalf
/initiative start
/spell fireball
/monster goblin
```

### Webhooks

Send game events to Discord:

```javascript
// Configure in Campaign Settings
{
  "webhookUrl": "https://discord.com/api/webhooks/...",
  "events": [
    "combat_started",
    "character_death",
    "critical_hit",
    "level_up"
  ]
}
```

## API Integration

### Getting Your API Key

1. Go to Account Settings
2. Navigate to API section
3. Click "Generate API Key"
4. Store securely

### Authentication

Include API key in requests:

```javascript
fetch('https://api.threatlvl.games/v1/endpoint', {
  headers: {
    'Authorization': 'Bearer YOUR_API_KEY',
    'Content-Type': 'application/json'
  }
});
```

### Rate Limits

| Account Type | Requests/Day | Burst Rate |
|--------------|--------------|------------|
| Free | 100 | 10/minute |
| Premium | 10,000 | 100/minute |

For complete API documentation, see the [API Reference](/docs/guides/api-reference/).

## Mobile Apps

### iOS Shortcuts

Create Siri shortcuts:

1. Download iOS Shortcuts app
2. Import ThreatLvl shortcuts
3. Use voice commands:
   - "Roll initiative"
   - "Check my character"
   - "Look up spell"

### Android Integration

Use Tasker or similar apps:

1. Create API request tasks
2. Add home screen widgets
3. Set up voice commands

## Streaming Integration

### OBS Overlay

Display game info on stream:

1. Add Browser Source in OBS
2. Use overlay URL:
   ```
   https://overlay.threatlvl.games/combat?key=YOUR_KEY
   ```
3. Configure visibility settings

### Twitch Extension

Install ThreatLvl Twitch extension:

Features:
- Show initiative tracker to viewers
- Display dice rolls
- Character sheet overlay
- Interactive polls

## Third-Party Tools

### Compatible Tools

ThreatLvl works with:

- **Avrae**: Discord dice roller
- **Fight Club 5e**: iOS/Android reference app
- **Game Master 5e**: Android GM tool
- **Improved Initiative**: Initiative tracker
- **Kobold Fight Club**: Encounter builder

### Data Export

Export data in standard formats:

- JSON (programmatic use)
- CSV (spreadsheets)
- XML (other tools)
- PDF (printing)

## Security Considerations

### API Key Management

- Never share your API key
- Rotate keys regularly
- Use environment variables
- Revoke compromised keys immediately

## Support & Resources

### Integration Support

Need help integrating?

- Email: integrations@threatlvl.games
- Documentation: [API Reference](/docs/guides/api-reference/)
- Examples: [GitHub Repository](https://github.com/danieljpost-dev/threatlvl.games-examples)

### Community Integrations

Check out community-built integrations:
- Browse our integration gallery
- Share your own integrations
- Get help from other developers

