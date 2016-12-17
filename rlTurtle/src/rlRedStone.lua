function pulseBundleWire(bundle_loc, color)
    local b_state=redstone.getBundledOutput(bundle_loc)
    rs.setBoundledOutput(bundle_loc, colors.combine(b_state,color))
    rs.setBoundledOutput(bundle_loc, colors.subtract(b_state,color))
end

function setBundleWire(bundle_loc, color)
    local b_state=redstone.getBundledOutput(bundle_loc)
    rs.setBoundledOutput(bundle_loc, colors.combine(b_state,color))
end

function clearBundleWire(bundle_loc, color)
    local b_state=redstone.getBundledOutput(bundle_loc)
    rs.setBoundledOutput(bundle_loc, colors.subtract(b_state,color))
end
