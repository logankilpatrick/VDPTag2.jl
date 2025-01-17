using VDPTag2
using Plots
using POMDPToolbox
using Reel
using ProgressMeter
using ParticleFilters
using StaticArrays

frames = Frames(MIME("image/png"), fps=2)

# pomdp = VDPTagPOMDP()
pomdp = VDPTagPOMDP(mdp=VDPTagMDP(barriers=CardinalBarriers(0.2, 2.8)))
policy = ManageUncertainty(pomdp, 0.01)
# policy = ToNextML(mdp(pomdp))

rng = MersenneTwister(5)

hr = HistoryRecorder(max_steps=30, rng=rng)
filter = SIRParticleFilter(pomdp, 200, rng=rng)
hist = simulate(hr, pomdp, policy, filter)

gr()
@showprogress "Creating gif..." for i in 1:n_steps(hist)
    push!(frames, plot(pomdp, view(hist, 1:i)))
end

filename = string(tempname(), "_vdprun.gif")
write(filename, frames)
println(filename)
run(`setsid xdg-open $filename`)
