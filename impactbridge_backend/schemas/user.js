export default {
        name: 'user',
        title: 'User',
        type: 'document',
        fields: [
                {
                        name: 'fullName',
                        title: 'Full Name',
                        type: 'string',
                },
                {
                        name: 'email',
                        title: 'Email',
                        type: 'string',
                },
                {
                        name: 'role',
                        title: 'Role',
                        type: 'string',
                },
                {
                        name: 'password',
                        title: 'Password',
                        type: 'string',
                },
                {
                        name: 'contactNo',
                        title: 'ContactNo',
                        type: 'string',
                },
                {
                        name: 'profilePicture',
                        title: 'Profile Picture',
                        type: 'image',
                        options: {
                                hotspot: true
                        }
                }
        ]
}