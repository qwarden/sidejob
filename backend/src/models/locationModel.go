package models

type Location struct {
	Zip     string `json:"zip" gorm:"primaryKey"`
	City    string `json:"city"`
	State   string `json:"state"`
	Address string `json:"address"`

	// TODO: Use GeoJSON if we want users to be able to filter jobs by proximity or set job with precise location
	// MapKit or Mapbox for frontend
	// for mapkit use MKGeoJSONDecoder and MKGeoJSONFeature
	//
	// // Latitude  float64 `json:"latitude"`
	// // Longitude float64 `json:"longitude"`
}
