// @ts-check
import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';

export default defineConfig({
  site: 'https://Oladiman.github.io',
  base: '/iron-scrolls',
  integrations: [
    starlight({
      title: 'Iron Scrolls',
      description:
        'Claude Code custom slash commands. Clone, install, and ship faster.',
      logo: {
        light: './src/assets/logo-light.svg',
        dark: './src/assets/logo-dark.svg',
        replacesTitle: false,
      },
      social: [
        {
          icon: 'github',
          label: 'GitHub',
          href: 'https://github.com/Oladiman/iron-scrolls',
        },
      ],
      customCss: ['./src/styles/custom.css'],
      components: {
        Footer: './src/components/Footer.astro',
      },
      sidebar: [
        {
          label: 'Get Started',
          items: [{ label: 'Installation', slug: 'install' }],
        },
        {
          label: 'Commands',
          items: [
            { label: '/seo-audit', slug: 'commands/seo-audit' },
            { label: '/accessibility-audit', slug: 'commands/accessibility-audit' },
            { label: '/performance-audit', slug: 'commands/performance-audit' },
            { label: '/security-audit', slug: 'commands/security-audit' },
            { label: '/pr-review', slug: 'commands/pr-review' },
            { label: '/api-design-review', slug: 'commands/api-design-review' },
          ],
        },
      ],
      head: [
        {
          tag: 'meta',
          attrs: {
            property: 'og:image',
            content: 'https://Oladiman.github.io/iron-scrolls/og.png',
          },
        },
      ],
    }),
  ],
});
