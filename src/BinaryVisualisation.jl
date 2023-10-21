module BinaryVisualisation

# Inspiration:
#   https://www.youtube.com/watch?v=4bM3Gut1hIk

using Images, FileIO, QuartzImageIO, Colors

const MAP_SIZE = 256

function binviz(input_file_path::AbstractString)
    contents = read(input_file_path)
    isempty(contents) && error("Handling empty files is not yet implemented")

    freq_map = zeros(Int, MAP_SIZE, MAP_SIZE)
    pixels = zeros(MAP_SIZE, MAP_SIZE)

    # D gram analysis
    for i in 1:(length(contents) - 1)
        x = contents[i] + 1
        y = contents[i + 1] + 1
        freq_map[y, x] += 1
    end

    # Normalise frequencies between 0 and 1
    m = maximum(log, freq_map)
    pixels = Matrix{RGB}(undef, MAP_SIZE, MAP_SIZE)
    for i in eachindex(freq_map)
        t = log(freq_map[i])/m
        isinf(t) && (t = 0.0)
        # reinterpret(RGB24, t * 255)
        pixels[i] = RGB(t)
    end

    # Save output
    output_file_path = input_file_path * ".binviz.png"
    save(output_file_path, pixels)
    return output_file_path
end

end  # end BinaryVisualisation
