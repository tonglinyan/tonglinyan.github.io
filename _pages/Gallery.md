---
layout: archive
title: "Gallery"
permalink: /gallery/
author_profile: true
---

{% include base_path %}

<style>
  .photo-grid {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 4px;
    margin-top: 1em;
  }
  @media (max-width: 500px) { .photo-grid { grid-template-columns: repeat(2, 1fr); } }
  .photo-grid a {
    display: block;
    aspect-ratio: 1 / 1;
    overflow: hidden;
    background: #f2f3f3;
  }
  .photo-grid img {
    display: block;
    width: 100%;
    height: 100%;
    object-fit: cover;
    transition: transform 0.3s ease, opacity 0.3s ease;
  }
  .photo-grid a:hover img { transform: scale(1.03); opacity: 0.9; }
</style>

Some photos I've taken along the way.

{% assign thumbs = site.static_files | where_exp: "f", "f.path contains '/images/gallery/thumbs/'" | map: "name" %}
{% assign photos = site.static_files | where_exp: "f", "f.path contains '/images/gallery/'" | sort: "path" | reverse %}

<div class="photo-grid" id="photo-grid">
{% for photo in photos %}
  {% if photo.path contains '/thumbs/' %}{% continue %}{% endif %}
  {% assign ext = photo.extname | downcase %}
  {% if ext == ".jpg" or ext == ".jpeg" or ext == ".png" or ext == ".gif" or ext == ".webp" %}
    {% assign caption = site.data.gallery[photo.name] %}
    {% if thumbs contains photo.name %}
      {% assign thumb = "/images/gallery/thumbs/" | append: photo.name %}
    {% else %}
      {% assign thumb = photo.path %}
    {% endif %}
  <a href="{{ base_path }}{{ photo.path }}" class="image-popup"{% if caption %} title="{{ caption }}"{% endif %}>
    <img src="{{ base_path }}{{ thumb }}" alt="{{ caption | default: photo.basename }}" loading="lazy">
  </a>
  {% endif %}
{% endfor %}
</div>

<script>
  // Shuffle the photos on each visit (runs before the lightbox is set up)
  (function () {
    var grid = document.getElementById("photo-grid");
    var items = Array.prototype.slice.call(grid.children);
    for (var i = items.length - 1; i > 0; i--) {
      var j = Math.floor(Math.random() * (i + 1));
      var tmp = items[i]; items[i] = items[j]; items[j] = tmp;
    }
    items.forEach(function (el) { grid.appendChild(el); });
  })();
</script>
