# Active Analysis

A collection of active storage analyzers

[![active-analysis-main](https://github.com/FestaLab/active_analysis/actions/workflows/main.yml/badge.svg)](https://github.com/FestaLab/active_analysis/actions/workflows/main.yml)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'active_analysis'
```

And then execute:

    $ bundle install

## Usage

Active Analysis automatically replaces all of Rails default analyzers with its own. It will not remove other custom analyzers if you have them. You can also configure which analyzers will be inserted.

```ruby
Rails.application.configure do |config|
  config.active_analysis.image_library  = :vips # Defaults to the same as active storage
  config.active_analysis.image_analyzer = true  # Defaults to true
  config.active_analysis.audio_analyzer = true  # Defaults to true
  config.active_analysis.pdf_analyzer   = false # Defaults to true
  config.active_analysis.video_analyzer = false # Defaults to true
end
```

#### Image
A modification of the original image analyzer and a new analyzer. Requires the [ImageMagick](http://www.imagemagick.org) system library or the [libvips](https://github.com/libvips/libvips) system library.

- Width (pixels)
- Height (pixels)
- Opaque (true if file is opaque, false if not)

An image will be considered opaque if it does not have an alpha channel, or if none of its pixels have an alpha value below the minimum (as defined by the library).

#### PDF
A new analyzer. Requires the [poppler](https://poppler.freedesktop.org/) system library.

- Width (pixels)
- Height (pixels)
- Pages

#### Audio
A new analyzer. Requires the [FFmpeg](https://www.ffmpeg.org) system library.

- Duration (seconds)
- Bit Rate (bits/second)

#### Video
A modification of the original video analyzer. Requires the [FFmpeg](https://www.ffmpeg.org) system library

- Width (pixels)
- Height (pixels)
- Duration (seconds)
- Angle (degrees)
- Display aspect ratio
- Audio (true if file has an audio channel, false if not)
- Video (true if file has an video channel, false if not)

## Addons
Active Analysis allows additional features to be added to the image analyzers through addons. To create an addon simply inherit the `Addon` class and add it to the addons array in the configuration.
```ruby
Rails.application.configure do |config|
  config.active_analysis.addons << ActiveAnalysis::Addon::ImageAddon::OptimalQuality
end
```

The following addons available:
- ImageAddon::OptimalQuality: An EXPERIMENTAL addon that calculates the optimal image quality using a DSSIM of 0.001. This addons is pretty resource hungry.
- ImageAddon::WhiteBackground: An EXPERIMENTAL addon that checks if the image has a white background. Requires both vips and image magick to be installed.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/FestaLab/active_analysis. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/FestaLab/active_analysis/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ActiveAnalysis project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/FestaLab/active_analysis/blob/main/CODE_OF_CONDUCT.md).
