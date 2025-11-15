+++
title = "API Reference"
description = "Complete REST API documentation"
weight = 3
+++

# API Reference

Complete reference for the ThreatLvl Games REST API.

## Base URL

```
https://api.threatlvl.games/v1
```

## Authentication

All API requests require authentication using an API key.

### Getting an API Key

1. Log in to ThreatLvl Games
2. Go to Account Settings → API
3. Click "Generate New Key"
4. Copy and store securely

### Using Your API Key

Include your API key in the Authorization header:

```http
Authorization: Bearer YOUR_API_KEY
```

### Example Request

```javascript
fetch('https://api.threatlvl.games/v1/characters', {
  headers: {
    'Authorization': 'Bearer YOUR_API_KEY',
    'Content-Type': 'application/json'
  }
})
```

## Rate Limiting

| Account Type | Daily Limit | Rate Limit |
|--------------|-------------|------------|
| Free | 100 requests | 10/minute |
| Premium | 10,000 requests | 100/minute |

### Rate Limit Headers

```http
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 95
X-RateLimit-Reset: 1699977600
```

## Response Format

### Success Response

```json
{
  "success": true,
  "data": {
    // Response data
  }
}
```

### Error Response

```json
{
  "success": false,
  "error": {
    "code": "INVALID_REQUEST",
    "message": "Character not found",
    "details": {}
  }
}
```

### HTTP Status Codes

| Code | Description |
|------|-------------|
| 200 | Success |
| 201 | Created |
| 400 | Bad Request |
| 401 | Unauthorized |
| 403 | Forbidden |
| 404 | Not Found |
| 429 | Rate Limit Exceeded |
| 500 | Internal Server Error |

## Characters Endpoint

### List Characters

```http
GET /characters
```

Query Parameters:
- `campaign` (optional): Filter by campaign ID
- `limit` (optional): Results per page (default: 20)
- `offset` (optional): Pagination offset

### Get Character

```http
GET /characters/{id}
```

Returns complete character data including stats, spells, and equipment.

### Create Character

```http
POST /characters
```

Request Body:
```json
{
  "name": "Aragorn",
  "class": "Fighter",
  "race": "Human",
  "level": 10,
  "abilityScores": {
    "strength": 18,
    "dexterity": 14,
    "constitution": 16,
    "intelligence": 12,
    "wisdom": 14,
    "charisma": 13
  }
}
```

## Dice Rolling Endpoint

### Roll Dice

```http
POST /dice/roll
```

Request Body:
```json
{
  "expression": "2d20kh1+5",
  "characterId": "char_123"
}
```

Response:
```json
{
  "success": true,
  "data": {
    "expression": "2d20kh1+5",
    "total": 23,
    "breakdown": [
      { "type": "d20", "value": 18, "kept": true },
      { "type": "d20", "value": 12, "kept": false },
      { "type": "modifier", "value": 5 }
    ],
    "natural": 18,
    "isCritical": false
  }
}
```

## Combat Endpoint

### Start Combat

```http
POST /combat/start
```

Request Body:
```json
{
  "name": "Goblin Ambush",
  "combatants": [
    {
      "type": "character",
      "id": "char_123"
    },
    {
      "type": "monster",
      "id": "goblin",
      "count": 4
    }
  ]
}
```

### Update Combatant

```http
PATCH /combat/{combatId}/combatants/{combatantId}
```

### Next Turn

```http
POST /combat/{combatId}/next-turn
```

### End Combat

```http
POST /combat/{combatId}/end
```

## Spells Endpoint

### Search Spells

```http
GET /spells/search
```

Query Parameters:
- `q`: Search query
- `class`: Filter by class
- `level`: Filter by spell level
- `school`: Filter by school
- `ritual`: Filter ritual spells (true/false)
- `concentration`: Filter concentration spells (true/false)

### Get Spell Details

```http
GET /spells/{id}
```

Returns full spell description, scaling, and effects.

## Monsters Endpoint

### Search Monsters

```http
GET /monsters/search
```

Query Parameters:
- `q`: Search query
- `cr`: Challenge rating
- `type`: Monster type
- `environment`: Environment

### Get Monster

```http
GET /monsters/{id}
```

Returns complete stat block including actions, abilities, and description.

## Encounters Endpoint

### Create Encounter

```http
POST /encounters
```

Request Body:
```json
{
  "name": "Forest Ambush",
  "partySize": 4,
  "partyLevel": 5,
  "monsters": [
    { "id": "owlbear", "count": 2 }
  ]
}
```

### Get Encounter

```http
GET /encounters/{id}
```

### List Encounters

```http
GET /encounters
```

## Campaigns Endpoint

### List Campaigns

```http
GET /campaigns
```

### Get Campaign

```http
GET /campaigns/{id}
```

### Create Campaign

```http
POST /campaigns
```

Request Body:
```json
{
  "name": "Lost Mine of Phandelver",
  "description": "A classic adventure",
  "system": "5e"
}
```

## Webhooks Endpoint

### Register Webhook

```http
POST /webhooks
```

Request Body:
```json
{
  "url": "https://your-server.com/webhook",
  "events": [
    "character.created",
    "character.updated",
    "combat.started",
    "combat.ended"
  ]
}
```

### List Webhooks

```http
GET /webhooks
```

### Delete Webhook

```http
DELETE /webhooks/{id}
```

### Webhook Events

Available event types:
- `character.created`
- `character.updated`
- `character.deleted`
- `combat.started`
- `combat.ended`
- `combat.turn_changed`
- `spell.cast`
- `dice.rolled`

## Error Codes

| Code | Description |
|------|-------------|
| `INVALID_REQUEST` | Request parameters invalid |
| `UNAUTHORIZED` | Invalid or missing API key |
| `NOT_FOUND` | Resource not found |
| `RATE_LIMIT_EXCEEDED` | Too many requests |
| `INTERNAL_ERROR` | Server error |

## SDKs & Libraries

### JavaScript/TypeScript

```bash
npm install @threatlvl/games-js
```

```javascript
import { ThreatLvlClient } from '@threatlvl/games-js';

const client = new ThreatLvlClient('YOUR_API_KEY');

const character = await client.characters.get('char_123');
const roll = await client.dice.roll('1d20+5');
```

### Python

```bash
pip install threatlvl-games
```

```python
from threatlvl import ThreatLvlClient

client = ThreatLvlClient('YOUR_API_KEY')

character = client.characters.get('char_123')
roll = client.dice.roll('1d20+5')
```

## Support

### Documentation
- Full docs: https://threatlvl.games/docs/
- GitHub: https://github.com/danieljpost-dev/threatlvl.games

### Contact
- Email: api@threatlvl.games
- Discord: https://discord.gg/threatlvl

