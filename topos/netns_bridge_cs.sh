source "$ROOTDIR/topos/netns.sh"

st_topo_setup()
{
	st_c_eth=(br1 br2)
	st_s_eth=(br1 br2)
	st_c_ethx=(eth1 eth2)
	st_s_ethx=(eth1 eth2)

	st_c_ip6=(2000::1 1000::1)
	st_s_ip6=(2000::2 1000::2)
	st_c_ip4=(192.0.0.1 172.0.0.1)
	st_s_ip4=(192.0.0.2 172.0.0.2)

	st_netns_ns_create c s
	st_netns_veth_create c "${st_c_ethx[*]}" s "${st_s_ethx[*]}"

	st_netns_bridges_create c "${st_c_eth[*]}"
	st_netns_bridges_create s "${st_s_eth[*]}"

	st_netns_bridge_add_veths c "${st_c_eth[0]}" "${st_c_ethx[0]}"
	st_netns_bridge_add_veths c "${st_c_eth[1]}" "${st_c_ethx[1]}"

	st_netns_bridge_add_veths s "${st_s_eth[0]}" "${st_s_ethx[0]}"
	st_netns_bridge_add_veths s "${st_s_eth[1]}" "${st_s_ethx[1]}"

	st_netns_addr_assign c "${st_c_eth[*]}" "${st_c_ip4[*]}" "24 16"
	st_netns_addr_assign s "${st_s_eth[*]}" "${st_s_ip4[*]}" "24 16"
	st_netns_addr_assign c "${st_c_eth[*]}" "${st_c_ip6[*]}" "64 128"
	st_netns_addr_assign s "${st_s_eth[*]}" "${st_s_ip6[*]}" "64 128"
}

st_topo_clean()
{
	st_netns_bridges_destroy c "${st_c_eth[*]}"
	st_netns_bridges_destroy s "${st_s_eth[*]}"
	st_netns_ns_destroy c s
}
