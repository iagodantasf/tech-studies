---
title: Geo queries
track: elasticsearch
group: Advanced Search Features
tags: [elasticsearch, geo]
prerequisites: [mappings, query-vs-filter-context]
see-also: [term-level-queries, bucket-aggregations, sorting]
---

# Geo queries

Spatial filtering and ranking over `geo_point` and `geo_shape` fields: find documents within a radius, bounding box, or arbitrary polygon, and sort or aggregate by distance.

## Why it matters

"Stores within 5 km", "deliveries inside this zone", "incidents in the map viewport" are core to commerce, logistics, and mapping. Geo queries push this to the index instead of fetching everything and filtering in the app, and they integrate with [[sorting]] (nearest-first) and [[bucket-aggregations|geo aggregations]] (heatmaps, clustering).

## How it works

Coordinates are indexed into a hierarchical spatial structure (a [[trees|BKD tree]] for points), turning geo predicates into fast range lookups.

| Field type | Stores | Use for |
|---|---|---|
| `geo_point` | lat/lon point | distance, bounding box, point-in-zone |
| `geo_shape` | points, lines, polygons | overlaps, contains, intersects |

- **`geo_distance`** — circle around a point; tune `distance` (e.g. `"5km"`) and rely on the BKD index, no `distance_type` arc cost for the filter itself.
- **`geo_bounding_box`** — top-left/bottom-right corners; cheapest geo query, ideal for map viewports.
- **`geo_shape` relations** — `intersects` (default), `within`, `contains`, `disjoint`.
- **Lives in [[query-vs-filter-context|filter context]]** — geo predicates are yes/no, so they don't score; cacheable.
- **`_geo_distance` sort** — orders hits by distance; **`geo_distance` aggregation** buckets by range rings.

## Example

```
PUT /shop { "mappings": { "properties": { "loc": { "type": "geo_point" } } } }

POST /shop/_search { "query": { "bool": { "filter": {
    "geo_distance": { "distance": "5km", "loc": { "lat": 40.71, "lon": -74.0 } } } } },
  "sort": [ { "_geo_distance": {
    "loc": { "lat": 40.71, "lon": -74.0 }, "order": "asc", "unit": "km" } } ] }
```

Returns shops within 5 km of lower Manhattan, nearest first; `sort` emits each hit's distance in km.

## Pitfalls

- **lat/lon order** — GeoJSON arrays are `[lon, lat]` but object/string forms are `lat, lon`; swapping them silently lands points in the ocean.
- **Unindexed sort/agg** — `_geo_distance` sort computes per hit; on huge result sets pre-filter with `geo_distance` so you sort few docs.
- **Invalid polygons** — self-intersecting `geo_shape` polygons are rejected or coerced; set `ignore_malformed` deliberately, not blindly.
- **Precision vs cost** — older `geohash`/`quadtree` prefix trees traded accuracy for size; modern BKD-backed shapes make `precision` tuning largely unnecessary — don't copy stale configs.

## See also

- [[bucket-aggregations]]
- [[sorting]]
