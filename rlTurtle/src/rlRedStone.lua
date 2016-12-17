
function pulseBundleWire(bundle_loc, color)
    local b_state=redstone.getBundledOutput(bundle_loc)    
    redstone.setBundledOutput(bundle_loc, colours.combine(b_state,color))
    redstone.setBundledOutput(bundle_loc, colours.subtract(b_state,color))
end

function setBundleWire(bundle_loc, color)
    local b_state=redstone.getBundledOutput(bundle_loc)
    redstone.setBundledOutput(bundle_loc, colors.combine(b_state,color))
end

function clearBundleWire(bundle_loc, color)
    local b_state=redstone.getBundledOutput(bundle_loc)
    redstone.setBundledOutput(bundle_loc, colors.subtract(b_state,color))
end
