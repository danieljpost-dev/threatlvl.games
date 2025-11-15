# ThreatLvl Games Documentation

[![Built with Zola](https://img.shields.io/badge/Built%20with-Zola-orange)](https://www.getzola.org/)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

Professional documentation site for ThreatLvl Games - a comprehensive suite of 5e-compatible online tabletop RPG tools.

🌐 **Live Site:** [threatlvl.games](https://threatlvl.games)

## 🎯 What is ThreatLvl Games?

ThreatLvl Games provides five core tools for running and playing 5e-compatible tabletop RPG games:

- **🎲 Dice Roller** - Advanced dice rolling with complex expressions and modifiers
- **⚔️ Character Builder** - Complete character creation and management system
- **👥 Initiative Tracker** - Combat turn tracking with HP and condition management
- **⚡ Spell Tracker** - Comprehensive spell management and SRD spell database
- **🐉 Encounter Builder** - CR-balanced encounter design with automatic difficulty calculation

## 🚀 Quick Start

### Prerequisites

- **Zola** static site generator (v0.18.0 or later)
- A modern web browser

### Installation

1. **Install Zola**

   **Linux/macOS:**
   ```bash
   curl -sL https://github.com/getzola/zola/releases/download/v0.18.0/zola-v0.18.0-x86_64-unknown-linux-gnu.tar.gz | tar xz
   sudo mv zola /usr/local/bin/
   ```

   **macOS (Homebrew):**
   ```bash
   brew install zola
   ```

   **Windows:**
   ```powershell
   scoop install zola
   # or
   choco install zola
   ```

   For other platforms, see [Zola installation docs](https://www.getzola.org/documentation/getting-started/installation/).

2. **Clone the repository**
   ```bash
   git clone https://github.com/danieljpost-dev/threatlvl.games.git
   cd threatlvl.games
   ```

3. **Serve locally**
   ```bash
   zola serve
   ```

   The site will be available at `http://127.0.0.1:1111`

## 📁 Project Structure

```
threatlvl.games/
├── config.toml              # Zola configuration
├── content/                 # Markdown content files
│   ├── _index.md           # Homepage content
│   ├── docs/               # Documentation section
│   │   ├── intro.md        # Introduction page
│   │   ├── tools/          # Tool documentation
│   │   │   ├── character-builder.md
│   │   │   ├── dice-roller.md
│   │   │   ├── encounter-builder.md
│   │   │   ├── initiative-tracker.md
│   │   │   └── spell-tracker.md
│   │   └── guides/         # Comprehensive guides
│   │       ├── getting-started.md
│   │       ├── integration.md
│   │       └── api-reference.md
│   └── blog/               # Blog posts
│       └── 2025-11-14-welcome.md
├── templates/              # Tera HTML templates
│   ├── base.html          # Base layout
│   ├── index.html         # Homepage template
│   ├── page.html          # Documentation page template
│   ├── docs-section.html  # Section overview template
│   ├── blog.html          # Blog listing template
│   ├── taxonomy_list.html # Tag listing template
│   └── taxonomy_single.html # Single tag template
├── sass/                  # Stylesheets
│   └── style.scss         # Main SCSS file
├── static/                # Static assets (images, fonts, etc.)
├── public/                # Generated site (git-ignored)
└── README.md             # This file
```

## 🛠️ Development

### Running the Development Server

```bash
zola serve
```

Options:
- `--port 8080` - Change the port (default: 1111)
- `--interface 0.0.0.0` - Listen on all interfaces
- `--open` - Automatically open browser

The development server includes:
- **Live reload** - Changes automatically refresh the browser
- **Fast rebuild** - Incremental builds in ~50ms
- **Draft support** - View draft pages

### Building for Production

```bash
zola build
```

The built site will be in the `public/` directory.

For production optimization:
```bash
zola build --output-dir public
```

### Checking the Site

Validate internal links and site structure:
```bash
zola check
```

## 📝 Creating Content

### Adding a New Documentation Page

1. Create a new Markdown file in the appropriate directory:
   ```bash
   touch content/docs/tools/new-tool.md
   ```

2. Add front matter:
   ```markdown
   +++
   title = "New Tool"
   description = "Description of the new tool"
   weight = 6
   +++

   # New Tool

   Your content here...
   ```

3. The page will automatically appear in the navigation sidebar.

### Adding a Blog Post

1. Create a new post:
   ```bash
   touch content/blog/2025-11-15-my-post.md
   ```

2. Add front matter with tags:
   ```markdown
   +++
   title = "My Blog Post"
   date = 2025-11-15
   description = "Post description"
   [taxonomies]
   tags = ["announcement", "feature"]
   +++

   Your content here...
   ```

### Front Matter Reference

Common front matter fields:

```toml
+++
title = "Page Title"              # Required
description = "Page description"  # Recommended for SEO
weight = 1                        # Sort order (lower = first)
draft = false                     # Set true to hide from production
template = "page.html"            # Override default template
[taxonomies]
tags = ["tag1", "tag2"]          # For blog posts
+++
```

## 🎨 Customization

### Changing Colors

Edit `sass/style.scss`:

```scss
// Primary colors
$primary-color: #8b2635;
$primary-dark: #7d2230;
$primary-light: #c94a5b;
```

### Modifying Templates

Templates use the [Tera](https://tera.netlify.app/) templating engine:

- Edit existing templates in `templates/`
- Base template (`base.html`) contains the site-wide layout
- Page-specific templates extend the base template

### Adding Custom CSS

Add styles to `sass/style.scss` - Zola automatically compiles Sass to CSS.

## 🚢 Deployment

### GitHub Pages

1. Build the site:
   ```bash
   zola build
   ```

2. Deploy to GitHub Pages:
   ```bash
   # Using gh-pages branch
   git subtree push --prefix public origin gh-pages
   ```

### Netlify

1. Connect your repository to Netlify
2. Configure build settings:
   - **Build command:** `zola build`
   - **Publish directory:** `public`
   - **Zola version:** `0.18.0`

### Vercel

1. Connect your repository to Vercel
2. Configure build settings:
   - **Framework Preset:** Other
   - **Build Command:** `zola build`
   - **Output Directory:** `public`

### Custom Server

```bash
# Build the site
zola build

# Copy public/ directory to your web server
rsync -avz public/ user@server:/var/www/html/
```

## 📊 Site Features

- ✅ **Fast builds** - Complete site builds in ~250ms
- ✅ **Responsive design** - Mobile-first, works on all devices
- ✅ **Search** - Built-in search functionality
- ✅ **RSS feeds** - Automatic feed generation
- ✅ **Syntax highlighting** - 20+ programming languages
- ✅ **Navigation** - Automatic sidebar generation
- ✅ **Tags** - Taxonomy support for blog posts
- ✅ **SEO optimized** - Meta tags, Open Graph, structured data
- ✅ **Live reload** - Instant preview during development

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Build and test locally (`zola serve`)
5. Commit your changes (`git commit -m 'Add amazing feature'`)
6. Push to the branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

### Writing Guidelines

- Use clear, concise language
- Include code examples where appropriate
- Add screenshots for UI-related documentation
- Follow the existing documentation structure
- Test all links before committing

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🔗 Links

- **Website:** [threatlvl.games](https://threatlvl.games)
- **Documentation:** [threatlvl.games/docs](https://threatlvl.games/docs)
- **API Reference:** [threatlvl.games/docs/guides/api-reference](https://threatlvl.games/docs/guides/api-reference)
- **GitHub:** [github.com/danieljpost-dev/threatlvl.games](https://github.com/danieljpost-dev/threatlvl.games)
- **Discord:** [discord.gg/your-invite](https://discord.gg/your-invite)

## 🙏 Acknowledgments

- Built with [Zola](https://www.getzola.org/) static site generator
- Typography using [Inter](https://rsms.me/inter/) font family
- Inspired by 5th Edition SRD content under the Open Game License
- Icons from standard Unicode emoji set

## 📞 Support

- **Issues:** [GitHub Issues](https://github.com/danieljpost-dev/threatlvl.games/issues)
- **Email:** support@threatlvl.games
- **Discord:** [Join our community](https://discord.gg/your-invite)

---

**Built with ⚔️ by game masters, for game masters.**

