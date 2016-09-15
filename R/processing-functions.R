####################
## idea: create a single point estimate for each demographic variable, 
## weighting the block group and tract estimates by the inverse of their 
## corresponding moe. 
#####################

# used to fill in median when data is missing
median_imputer <- function(col) {
    m <- median(col, na.rm=TRUE)
    ifelse(is.na(col), m, col)    
}

# function that, given bg and tract info with corresponding moes, 
# will return a single point estimate (using some weighting of the two)
# this should apply to rates and summaries, not counts!
combine_estimates <- function(bg, moe_bg, tract, moe_tract) {
    # this implementation is arbitrary. it just weights by the inverse of the 
    # moe's
    result <- (bg/moe_bg + tract/moe_tract) / (1/moe_bg + 1/moe_tract)
    result[is.na(bg)] <- tract[is.na(bg)]
    result
}

# function that, given numerator and denominator along with associated moes,
# calculates the moe of the derived estimate
ratio_moe <- function(numerator, numerator_moe, denominator, denominator_moe) {
    ratio <- numerator / denominator
    top <- sqrt((numerator_moe ^ 2) + ((ratio ^ 2) * (denominator_moe ^ 2)))
    top / denominator
}

# given all bg and tract estimates and moe's for numerator and denominator, 
# calculates a combined estimated ratio
combined_ratio <- function(num_bg, num_moe_bg, denom_bg, denom_moe_bg, 
                           num_tract, num_moe_tract, denom_tract, denom_moe_tract) {
    bg <- num_bg / denom_bg
    moe_bg <- ratio_moe(num_bg, num_moe_bg, denom_bg, denom_moe_bg)
    tract <- num_tract / denom_tract
    moe_tract <- ratio_moe(num_tract, num_moe_tract, denom_tract, denom_moe_tract)
    combine_estimates(bg, moe_bg, tract, moe_tract)
}
