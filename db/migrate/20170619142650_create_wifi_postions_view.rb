class CreateWifiPostionsView < ActiveRecord::Migration[5.0]
  def change

    change_column :wifi_observations, :observed_at, :datetime, default: Date.new(2000), null: false, index: true
    execute <<-SQL
CREATE MATERIALIZED VIEW wifi_positions AS
  SELECT DISTINCT bssid, id, longitude, latitude, 
      json_build_object(
        'type', 'Feature',
        'geometry', json_build_object(
          'type', 'Point',
          'coordinates', json_build_array(
            longitude,latitude
          )
        ),
        'properties', json_build_object(
          'id', id,
          'bssid', bssid,
          'ssid', ssid
        )
      )::text AS geojson, ssid
  FROM wifi_observations
  WHERE id = (
    SELECT wo.id
    FROM wifi_observations AS wo
    WHERE wo.bssid = wifi_observations.bssid
    ORDER BY 
      (SELECT EXTRACT(YEAR FROM wo.observed_at)) DESC,
      (SELECT EXTRACT(WEEK FROM wo.observed_at)) DESC,
      COALESCE((raw_info->>'signal_level'),'100')::int ASC
      LIMIT 1
  )
    SQL
    execute <<-SQL
create or replace function refresh_wifi_positions()
returns trigger language plpgsql
as $$
begin
    refresh materialized view wifi_positions;
    return null;
end $$;

create trigger refresh_wifi_positions_trigger
after insert or update or delete or truncate
on wifi_observations for each statement 
execute procedure refresh_wifi_positions();
    SQL
  end
end
