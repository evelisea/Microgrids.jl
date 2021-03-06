# abstract type Components end
# abstract type NonDispatchables <: Components end
abstract type NonDispatchables end

"Project information."
struct Project
    "lifetime (years)"
    lifetime
    "discount rate ∈ [0,1]"
    discount_rate
    "time step (h)"
    timestep
    # TODO dispatch_type?
end

"Diesel generator parameters."
struct DieselGenerator
    "Rated power (kW)"
    power_rated   # decision variable
    "Minimum load ratio ∈ [0,1]"
    minimum_load_ratio  # ever it is on, it will work at least `min_load_ratio` of the power_max
    # min_production = min_load_ratio * power_max   # TODO - maybe it's a internal variable
    "Fuel curve intercept coefficient (L/(h × kW))"
    F0
    "Fuel curve slope (L/(h × kW))"
    F1
    
    # economics
    "Fuel cost (currency unit/L)"
    fuel_cost
    "Investiment cost (currency unit/kW)"
    investment_cost
    "Operation and maintenance cost (currency unit/(kW.h))"
    om_cost
    "Replacement cost (currency unit/kW)"
    replacement_cost
    "Salvage cost (currency unit/kW)"
    salvage_cost
    "Lifetime (h)"
    lifetime
end

"Photovoltaic parameters."
struct Photovoltaic <: NonDispatchables
    "Rated power (kW)"
    power_rated   # decision variable
    "Derating factor ∈ [0,1]"
    derating_factor
    "Incident global solar radiation (kW/m²)"
    IT
    "Standard amount of global solar radiation (kW/m²)"
    IS

    # economics
    "Investiment cost (currency unit/kW)"
    investment_cost
    "Operation and maintenance cost (currency unit/kW)"
    om_cost
    "Replacement cost (currency unit/kW)"
    replacement_cost
    "Salvage cost (currency unit/kW)"
    salvage_cost
    "Lifetime (years)"
    lifetime

    # Photovoltaic(fPV, IT, IS, Y_PV) = new(fPV, IT, IS, Y_PV)
end

"Wind turbine parameters."
struct WindPower <: NonDispatchables
    "Rated power (kW)"
    power_rated
    "Cut-in speed (m/s)"
    U_cut_in
    "Cut-out speed (m/s)"
    U_cut_out
    "Rated speed (m/s)"
    U_rated
    "Wind speed at the measurement height (m/s)"
    Uanem
    "Hub height (m)"
    zhub
    "Measurement height (m)"
    zanem
    "Roughness length (m)"
    z0
    # TODO rho
    # TODO rho0

    # economics
    "Investiment cost (currency unit/kW)"
    investment_cost
    "Operation and maintenance cost (currency unit/kW)"
    om_cost
    "Replacement cost (currency unit/kW)"
    replacement_cost
    "Salvage cost (currency unit/kW)"
    salvage_cost
    "Lifetime (years)"
    lifetime
end

"Battery parameters."
struct Battery
    "Initial energy (kWh)"
    energy_initial
    "Rated energy capacity (kWh)"
    energy_max    # Eb_max
    "Minimum energy level (kWh)"
    energy_min    # Eb_min  TODO - it could be the minimum state of charge too
    "Maximum charge power ∈ ``\\mathbf{R}^-`` (kW)"
    power_min     # Pb_min - charge (negative)
    "Maximum discharge power (kW)"
    power_max     # Pb_max - discharge
    "Linear loss factor ∈ [0,1]"
    loss

    # economics
    "Investiment cost (currency unit/kWh)"
    investment_cost
    "Operation and maintenance cost (currency unit/kWh)"
    om_cost
    "Replacement cost (currency unit/kWh)"
    replacement_cost
    "Salvage cost (currency unit/kWh)"
    salvage_cost
    "Lifetime (years)"
    lifetime
    "Maximum number of cycles"
    lifetime_throughput  # max throughput
end

# Operation variables - Trajectory
struct OperVarsTraj
    # load
    #= "Net load at each time instant after using the renewables power (kW)"
    Pnl_req =#
    "Net load at each time instant after dispatch (kW)"
    power_net_load
    "Unmet load/Load shedding power at each time instant (kW)"
    power_shedding
    # diesel generator
    "Diesel generator power at each time instant (kW)"
    Pgen
    # battery
    "Battery energy at each time instant (kWh)"
    Ebatt
    "Battery power at each time instant (kW)"
    Pbatt
    "Maximum battery discharge power at time t (kW)"
    Pbatt_dmax
    "Maximum battery charge power at time t (kW)"
    Pbatt_cmax
    # renewables sources
    "Renewables curtailment power at each time instant (kW)"
    power_curtailment
end

# Operation variables - Aggregation
struct OperVarsAggr
    # load
    "Load energy served in one year (kWh)"
    energy_served
    "Maximum load shedding power (kW)"
    power_shedding_max
    "Maximum consecutive duration of load shedding (h)"
    shedding_duration_max
    "Load shedding energy in one year (kWh)"
    energy_shedding_total
    "Ratio between load shedding energy and total consumption in one year (%)"
    shedding_rate
    # diesel generator
    "Number of diesel generator operation hours in one year (h)"
    DG_operation_hours
    "Diesel consumption in one year (L)"
    fuel_consumption
    # battery
    "Number of completed battery cycles in one year"
    annual_throughput
    # renewables sources
    "Maximum renewables curtailment power (kW)"
    power_curtailment_max
    "Ratio between energy supplied by renewables and energy served in one year (%)"
    renewables_rate
end

# Total costs
struct TotalCosts
    # general
    "Levelized cost of electricity (currency unit)"
    lcoe
    "Cost of electricity (currency unit)"
    coe # annualized
    "Net present cost (currency unit)"
    npc
    "Present investment cost (currency unit)"
    total_investment_cost
    "Present replacement cost (currency unit)"
    total_replacement_cost
    "Present operation and maintenance cost (currency unit)"
    total_om_cost
    "Present salvage cost (currency unit)"
    total_salvage_cost

    # components
    "Generator's total present cost (currency unit)"
    DG_total_cost
    "Generator's present investment cost (currency unit)"
    DG_investment_cost
    "Generator's present replacement cost (currency unit)"
    DG_replacement_cost
    "Generator's present operation and maintenance cost (currency unit)"
    DG_om_cost
    "Generator's present salvage cost (currency unit)"
    DG_salvage_cost
    "Generator's present fuel cost (currency unit)"
    DG_fuel_cost

    "Battery's total present cost (currency unit)"
    BT_total_cost
    "Battery's present investment cost (currency unit)"
    BT_investment_cost
    "Battery's present replacement cost (currency unit)"
    BT_replacement_cost
    "Battery's present operation and maintenance cost (currency unit)"
    BT_om_cost
    "Battery's present salvage cost (currency unit)"
    BT_salvage_cost

    "Photovoltaic's total present cost (currency unit)"
    PV_total_cost
    "Photovoltaic's present investment cost (currency unit)"
    PV_investment_cost
    "Photovoltaic's present replacement cost (currency unit)"
    PV_replacement_cost
    "Photovoltaic's present operation and maintenance cost (currency unit)"
    PV_om_cost
    "Photovoltaic's present salvage cost (currency unit)"
    PV_salvage_cost

    "Wind turbine's total present cost (currency unit)"
    WT_total_cost
    "Wind turbine's present investment cost (currency unit)"
    WT_investment_cost
    "Wind turbine's present replacement cost (currency unit)"
    WT_replacement_cost
    "Wind turbine's present operation and maintenance cost (currency unit)"
    WT_om_cost
    "Wind turbine's present salvage cost (currency unit)"
    WT_salvage_cost
end

# Microgrid
struct Microgrid
    project::Project
    power_load
    dieselgenerator::DieselGenerator
    # photovoltaic::Photovoltaic
    # windpower::WindPower
    battery::Battery
    nondispatchables::Vector{NonDispatchables}
end
