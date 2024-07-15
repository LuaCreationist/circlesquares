local shader = {} 
function shader.load()
    blendSimilarShaderCode = [[
        extern vec4 color;
        extern number blendFactor;
        vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
            vec3 rgb = color.rgb; // Extract RGB components of the input color
            // Calculate the average of RGB components
            float avgColor = (rgb.r + rgb.g + rgb.b) / 3.0;
            // Calculate grayscale value for the input color
            vec3 grayscaleColor = vec3(avgColor);
            // Add noise to simulate a painterly effect
            float noise = (fract(sin(dot(texture_coords.xy ,vec2(12.9898,78.233))) * 43758.5453) - 0.5) * 0.1;
            // Calculate blending factor based on hue similarity with added noise
            vec3 delta = abs(rgb - grayscaleColor);
            float blend = 1.0 - dot(delta, vec3(1.0)) / 3.0 + noise;
            // Linearly blend between grayscale and original color based on blendFactor
            vec3 blendedColor = mix(grayscaleColor, rgb, clamp(blend * blendFactor, 0.0, 1.0));
            return vec4(blendedColor, 1.0);
        }
    ]]
    shader.blendSimilarShader = love.graphics.newShader(blendSimilarShaderCode)-- Create the shader object
    shader.blendSimilarShader:send("blendFactor", 0.5)  -- Set default values for shader parameters
end
return shader 