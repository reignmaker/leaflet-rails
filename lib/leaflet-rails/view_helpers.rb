require 'active_support/inflector'
module Leaflet
  module ViewHelpers

    def map(options)
      options[:tile_layer] ||= Leaflet.tile_layer
      options[:attribution] ||= Leaflet.attribution
      options[:max_zoom] ||= Leaflet.max_zoom
      options[:container_id] ||= 'map'

      tile_layer = options.delete(:tile_layer) || Leaflet.tile_layer
      attribution = options.delete(:attribution) || Leaflet.attribution
      max_zoom = options.delete(:max_zoom) || Leaflet.max_zoom
      container_id = options.delete(:container_id) || 'map'
      no_container = options.delete(:no_container)
      center = options.delete(:center)
      markers = options.delete(:markers)
      circles = options.delete(:circles)
      polylines = options.delete(:polylines)
      fitbounds = options.delete(:fitbounds)


      output = []
      output << "<div id='#{container_id}'></div>" unless no_container
      output << "<script>"
      output << "var map = L.map('#{container_id}')"

      if center
        output << "map.setView([#{center[:latlng][0]}, #{center[:latlng][1]}], #{center[:zoom]})"
      end

      if markers
        markers.each do |marker|
          output << "marker = L.marker([#{marker[:latlng][0]}, #{marker[:latlng][1]}]).addTo(map)"
          if marker[:popup]
            output << "marker.bindPopup('#{marker[:popup]}')"
          end
        end
      end

      if circles
        circles.each do |circle|
          output << "L.circle(['#{circle[:latlng][0]}', '#{circle[:latlng][1]}'], #{circle[:radius]}, {
           color: '#{circle[:color]}',
           fillColor: '#{circle[:fillColor]}',
           fillOpacity: #{circle[:fillOpacity]}
        }).addTo(map);"
        end
      end

      if polylines
         polylines.each do |polyline|
           _output = "L.polyline(#{polyline[:latlngs]}"
           _output << "," + polyline[:options].to_json if polyline[:options]
           _output << ").addTo(map);"
           output << _output.gsub(/\n/,'')
         end
      end

      if fitbounds
        output << "map.fitBounds(L.latLngBounds(#{fitbounds}));"
      end

      output << "L.tileLayer('#{tile_layer}', {
          attribution: '#{attribution}',
          maxZoom: #{max_zoom},"
          options.each do |key, value|
            output << "#{key.to_s.camelize(:lower)}: '#{value}',"
          end
 
      output << "}).addTo(map)"
      output << "</script>"
      output.join("\n").html_safe
    end

  end

end