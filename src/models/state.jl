struct State
    position::Position
    attitude::Attitude
    velocity::Array{T, 1} where T<:Number
    angular_velocity::Array{T, 1} where T<:Number
    acceleration::Array{T, 1} where T<:Number
    angular_acceleration::Array{T, 1} where T<:Number
end

# Position getters
get_position(state::State) = state.position
get_llh(state::State) = get_llh(state.position)
get_xyz_earth(state::State) = get_xyz_earth(state.position)
get_xyz_ecef(state::State) = get_xyz_ecef(state.position)
get_height(state::State) = get_height(state.position)
# Attitude getters
get_attitude(state::State) = state.attitude
get_euler_angles(state::State) = get_euler_angles(state.attitude)
get_quaternions(state::State) = get_quaternions(state.attitude)
# Velocity getters
get_body_velocity(state::State) = state.velocity
get_horizon_velocity(state::State) = body2hor(get_body_velocity(state)...,
                                              get_quaternions(state)...)
function get_flight_path_angle(state::State)
    vn, ve, vz = get_horizon_velocity(state)
    atan(-vz, norm([vn, ve]))
end

# Angular velocity getters
get_body_ang_velocity(state::State) = state.angular_velocity
get_turn_rate(state::State) = body2hor(get_body_ang_velocity(state)...,
                                       get_quaternions(state)...)[3]
# Acceleration getters
get_body_accel(state::State) = state.acceleration
get_horizon_accel(state::State) = body2hor(get_body_accel(state)...,
                                           get_quaternions(state)...)
# Angular acceleration getters
get_body_ang_accel(state::State) = state.angular_acceleration


function get_sixdof_euler_fixed_mass_state(state::State)
    [get_body_velocity(state)...,
     get_body_ang_velocity(state)...,
     get_euler_angles(state)...,
     get_xyz_earth(state)...]
end
