import { createClient } from "@sanity/client";
import imageUrlBuilder from '@sanity/image-url';

const config = {
    projectId: process.env.NEXT_PUBLIC_SANITY_PROJECT_ID,
    dataset: "production",
    apiVersion: '2023-10-05',
    useCdn: false,
    token: process.env.NEXT_PUBLIC_SANITY_TOKEN,
};

const Client = createClient(config);

const builder = imageUrlBuilder(Client);
export const urlFor = (source) => builder.image(source);

export default Client;