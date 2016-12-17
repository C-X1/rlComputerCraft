function pulseBundle(bundle_loc, color)
    local b_state=redstone.getBundledOutput(bundle_loc)
    rs.setBoundledOutput(bundle_loc, colors.combine(b_state,color))
    rs.setBoundledOutput(bundle_loc, colors.subtract(b_state,color))
end