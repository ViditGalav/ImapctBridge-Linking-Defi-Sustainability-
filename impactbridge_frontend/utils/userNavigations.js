export const investorNavigations = (userId) => {
    
    const navs = [
        {
            title: 'Investments',
            url: `/investor/${userId}/investments`,
        },
        {
            title: 'My NFTs',
            url: `/investor/${userId}/investor-nft`,
        },
        {
            title: 'Project Growth',
            url: `/investor/${userId}/project-growth`,
        },
        {
            title: 'More Projects',
            url: `/investor/${userId}/more-projects`,
        },
    ];

    return navs
    
}
export const projectOwnerNavigations = (userId) => {

    const navs = [
        {
            title: 'My Projects',
            url: `/powner/${userId}/projects`,
        },
        {
            title: 'Add Projects',
            url: `/powner/${userId}/add-projects`,
        },
        {
            title: 'Investor details',
            url: `/powner/${userId}/investor-details`,
        },
        {
            title: 'NFT details',
            url: `/powner/${userId}/powner-nft`,
        },
    ];

    return navs
} 