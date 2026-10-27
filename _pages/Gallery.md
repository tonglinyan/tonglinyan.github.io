---
layout: archive
title: "Gallery"
permalink: /gallery/
author_profile: true
---

{% include base_path %}

<style>
  .photo-grid {
    column-count: 3;
    column-gap: 0.75em;
    margin-top: 1em;
  }
  @media (max-width: 900px) { .photo-grid { column-count: 2; } }
  @media (max-width: 500px) { .photo-grid { column-count: 1; } }
  .photo-grid figure {
    break-inside: avoid;
    margin: 0 0 0.75em;
  }
  .photo-grid img {
    display: block;
    width: 100%;
    height: auto;
    border-radius: 4px;
    transition: opacity 0.2s ease;
  }
  .photo-grid a:hover img { opacity: 0.85; }
  .photo-grid figcaption {
    margin-top: 0.3em;
    font-size: 0.75em;
    color: #7a8288;
  }
</style>

Some photos I've taken along the way.

{% assign photos = site.static_files | where_exp: "f", "f.path contains '/images/gallery/'" | sort: "path" | reverse %}

<div class="photo-grid">
{% for photo in photos %}
  {% assign ext = photo.extname | downcase %}
  {% if ext == ".jpg" or ext == ".jpeg" or ext == ".png" or ext == ".gif" or ext == ".webp" %}
    {% assign caption = site.data.gallery[photo.name] %}
  <figure>
    <a href="{{ base_path }}{{ photo.path }}" class="image-popup"{% if caption %} title="{{ caption }}"{% endif %}>
      <img src="{{ base_path }}{{ photo.path }}" alt="{{ caption | default: photo.basename }}" loading="lazy">
    </a>
    {% if caption %}<figcaption>{{ caption }}</figcaption>{% endif %}
  </figure>
  {% endif %}
{% endfor %}
</div>
