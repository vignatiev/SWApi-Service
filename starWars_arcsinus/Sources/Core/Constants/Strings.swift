// swiftlint:disable all
// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable function_parameter_count identifier_name line_length type_body_length
internal enum LocalizedString {
  /// Average Height
  internal static let averageHeight = LocalizedString.tr("Localizable", "average-height")
  /// Average Lifespan
  internal static let averageLifespan = LocalizedString.tr("Localizable", "average-lifespan")
  /// Birth Year
  internal static let birthYear = LocalizedString.tr("Localizable", "birth-year")
  /// Cargo Capacity
  internal static let cargoCapacity = LocalizedString.tr("Localizable", "cargo-capacity")
  /// Classification
  internal static let classification = LocalizedString.tr("Localizable", "classification")
  /// Climate
  internal static let climate = LocalizedString.tr("Localizable", "climate")
  /// Consumables
  internal static let consumables = LocalizedString.tr("Localizable", "consumables")
  /// Cost in Credits
  internal static let costInCredits = LocalizedString.tr("Localizable", "cost-in-credits")
  /// Crew
  internal static let crew = LocalizedString.tr("Localizable", "crew")
  /// Designation
  internal static let designation = LocalizedString.tr("Localizable", "designation")
  /// Diameter
  internal static let diameter = LocalizedString.tr("Localizable", "diameter")
  /// Director
  internal static let director = LocalizedString.tr("Localizable", "director")
  /// Episode number
  internal static let episodeId = LocalizedString.tr("Localizable", "episode-id")
  /// An authorization error has occurred.
  internal static let errorsAuthError = LocalizedString.tr("Localizable", "errors-auth-error")
  /// An error occurred while accessing the server.
  internal static let errorsClientError = LocalizedString.tr("Localizable", "errors-client-error")
  /// An error occurred while processing the data received from the server.
  internal static let errorsMappingError = LocalizedString.tr("Localizable", "errors-mapping-error")
  /// No internet connection or very low connection speed.
  internal static let errorsNetworkError = LocalizedString.tr("Localizable", "errors-network-error")
  /// A server error occurred while executing the request.
  internal static let errorsServerError = LocalizedString.tr("Localizable", "errors-server-error")
  /// An unknown network error has occurred.
  internal static let errorsUnknownError = LocalizedString.tr("Localizable", "errors-unknown-error")
  /// Eye Color
  internal static let eyeColor = LocalizedString.tr("Localizable", "eye-color")
  /// Eye Colors
  internal static let eyeColors = LocalizedString.tr("Localizable", "eye-colors")
  /// Films
  internal static let films = LocalizedString.tr("Localizable", "films")
  /// Gender
  internal static let gender = LocalizedString.tr("Localizable", "gender")
  /// Gravity
  internal static let gravity = LocalizedString.tr("Localizable", "gravity")
  /// Hair Color
  internal static let hairColor = LocalizedString.tr("Localizable", "hair-color")
  /// Hair Colors
  internal static let hairColors = LocalizedString.tr("Localizable", "hair-colors")
  /// Height
  internal static let height = LocalizedString.tr("Localizable", "height")
  /// Homeworld
  internal static let homeworld = LocalizedString.tr("Localizable", "homeworld")
  /// Hyperdrive Rating
  internal static let hyperdriveRating = LocalizedString.tr("Localizable", "hyperdrive-rating")
  /// Language
  internal static let language = LocalizedString.tr("Localizable", "language")
  /// Length
  internal static let length = LocalizedString.tr("Localizable", "length")
  /// Manufacturer
  internal static let manufacturer = LocalizedString.tr("Localizable", "manufacturer")
  /// Mass
  internal static let mass = LocalizedString.tr("Localizable", "mass")
  /// Max Atmosphering Speed
  internal static let maxAtmospheringSpeed = LocalizedString.tr("Localizable", "max-atmosphering-speed")
  /// MGLT
  internal static let mglt = LocalizedString.tr("Localizable", "mglt")
  /// Model
  internal static let model = LocalizedString.tr("Localizable", "model")
  /// Name
  internal static let name = LocalizedString.tr("Localizable", "name")
  /// No results for your search.
  internal static let noResultsForYourSearch = LocalizedString.tr("Localizable", "no-results-for-your-search")
  /// Orbital Period
  internal static let orbitalPeriod = LocalizedString.tr("Localizable", "orbitalPeriod")
  /// Passengers
  internal static let passengers = LocalizedString.tr("Localizable", "passengers")
  /// People
  internal static let people = LocalizedString.tr("Localizable", "people")
  /// Pilots
  internal static let pilots = LocalizedString.tr("Localizable", "pilots")
  /// Population
  internal static let population = LocalizedString.tr("Localizable", "population")
  /// Producer
  internal static let producer = LocalizedString.tr("Localizable", "producer")
  /// Release Date
  internal static let releaseDate = LocalizedString.tr("Localizable", "releaseDate")
  /// Rotation Period
  internal static let rotationPeriod = LocalizedString.tr("Localizable", "rotationPeriod")
  /// Skin Color
  internal static let skinColor = LocalizedString.tr("Localizable", "skin-color")
  /// Skin Colors
  internal static let skinColors = LocalizedString.tr("Localizable", "skin-colors")
  /// Species
  internal static let species = LocalizedString.tr("Localizable", "species")
  /// Starship Class
  internal static let starshipClass = LocalizedString.tr("Localizable", "starship-class")
  /// Starships
  internal static let starships = LocalizedString.tr("Localizable", "starships")
  /// Surface Water
  internal static let surfaceWater = LocalizedString.tr("Localizable", "surfaceWater")
  /// Terrain
  internal static let terrain = LocalizedString.tr("Localizable", "terrain")
  /// Title
  internal static let title = LocalizedString.tr("Localizable", "title")
  /// Input Text To Find A Character
  internal static let typeToSearchLabel = LocalizedString.tr("Localizable", "type-to-search-label")
  /// Vehicle Class
  internal static let vehicleClass = LocalizedString.tr("Localizable", "vehicle-class")
  /// Vehicles
  internal static let vehicles = LocalizedString.tr("Localizable", "vehicles")
}
// swiftlint:enable function_parameter_count identifier_name line_length type_body_length

// MARK: - Implementation Details

extension LocalizedString {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
