-- Extraccion malla vial
SELECT
  MVICCALZAD       AS "Código de Identificación de Calzada",
  MVICCAT          AS "Código identificador UAECD",
  MVINPRINCI       AS "Nomenclatura principal",
  MVINGENERA       AS "Nomenclatura generadora",
  MVINANTIGU       AS "Nomenclatura antigua",
  MVIETIQUET       AS "Etiqueta",
  MVISVIA          AS "Sentido de la vía",
  MVICIV           AS "Código de Identificación Vial",
  MVIEVIA          AS "Estado de la vía",
  NAME             AS "Nombre vial más generadora",
  MUNICIPIO        AS "Municipio",
  MVICODIGO        AS "Código de Identificación MVI",
  MVI_VELREG       AS "Velocidad reglamentaria",
  Shape__Length    AS "Longitud geométrica del segmento"
FROM nombre_de_la_tabla;
-- Extraccion malla vial pero en mongo
db.nombre_de_la_tabla.find(
  {},
  {
    MVICCALZAD: 1,
    MVICCAT: 1,
    MVINPRINCI: 1,
    MVINGENERA: 1,
    MVINANTIGU: 1,
    MVIETIQUET: 1,
    MVISVIA: 1,
    MVICIV: 1,
    MVIEVIA: 1,
    NAME: 1,
    MUNICIPIO: 1,
    MVICODIGO: 1,
    MVI_VELREG: 1,
    Shape__Length: 1
  }
)

---
db.vias.aggregate([
  {
    $lookup: {
      from: "trafico",
      localField: "MVIEVIA",      // campo de nombre de la vía en 'vias'
      foreignField: "NAME_FROM",  // campo en 'trafico'
      as: "trafico_via"
    }
  },
  {
    $unwind: "$trafico_via"
  },
  {
    $project: {
      _id: 0,
      nombre_via: "$MVIEVIA",
      municipio: "$MUNICIPIO",
      velocidad_promedio: "$trafico_via.VEL_PROMEDIO",
      dia_semana: "$trafico_via.DIA_SEMANA",
      hora: "$trafico_via.HORA",
      longitud: "$Shape__Length",
      inicio: "$trafico_via.INICIO",
      fin: "$trafico_via.FIN"
    }
  }
])
---- velocidad promedio en una zona en un rango de horas
SELECT
  CONCAT(
    'Zone_', 
    FLOOR(ST_Y(geom)::numeric, 0.01), '_', 
    FLOOR(ST_X(geom)::numeric, 0.01)
  ) AS area_label,
  DATE_TRUNC('hour', te.timestamp) AS hour_slot,
  AVG(te.average_speed) AS avg_speed,
  AVG(te.congestion_level) AS avg_congestion,
  COUNT(*) AS event_count
FROM TrafficEvents te
JOIN RoadSegments rs ON rs.id = te.road_segment_id
WHERE te.timestamp BETWEEN '2025-05-01 00:00:00' AND '2025-05-07 23:59:59'
  AND rs.is_active = true
GROUP BY area_label, hour_slot
ORDER BY hour_slot, area_label;
------ comparacion entre un viaje guardado y las rutas sugeridas
SELECT
  tr.id AS trip_id,
  ars.estimated_time_min AS suggested_time,
  tr.duration_min AS actual_time,
  ars.congestion_score,
  COUNT(te.id) AS events_on_route,
  AVG(te.average_speed) AS avg_segment_speed
FROM TripRecords tr
JOIN AlternativeRouteSuggestions ars ON ars.trip_id = tr.id
JOIN RoadSegments rs ON ST_Intersects(ars.geometry, rs.geometry)
LEFT JOIN TrafficEvents te ON te.road_segment_id = rs.id
  AND te.timestamp BETWEEN tr.start_time AND tr.end_time
GROUP BY tr.id, ars.estimated_time_min, tr.duration_min, ars.congestion_score
ORDER BY tr.start_time DESC
LIMIT 5;