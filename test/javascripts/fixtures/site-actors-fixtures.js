export default {
  category: [
    {
      id: 1,
      handle: "@cat_1@test.local",
      name: "Cat 1",
      username: "cat_1",
      model_type: "Category",
      model_id: 1,
      can_admin: false,
      default_visibility: "public",
      publication_type: "first_post",
      post_object_type: "Note",
      enabled: true,
      ready: true,
    },
    {
      id: 2,
      handle: "@cat_2@test.local",
      name: "Cat 2",
      username: "cat_2",
      model_type: "Category",
      model_id: 2,
      can_admin: true,
      default_visibility: "public",
      publication_type: "first_post",
      post_object_type: "Note",
      enabled: true,
      ready: true,
    },
    {
      id: 3,
      handle: "@sub_cat_1@test.local",
      name: "Sub Cat 1",
      username: "sub_cat_1",
      model_type: "Category",
      model_id: 3,
      can_admin: true,
      default_visibility: "public",
      publication_type: "first_post",
      post_object_type: "Note",
      enabled: true,
      ready: true,
    },
  ],
  tag: [
    {
      id: 4,
      handle: "@monkey@test.local",
      name: "Monkey",
      username: "monkey",
      model_type: "Tag",
      model_id: 1,
      model_name: "monkey",
      can_admin: true,
      default_visibility: "public",
      publication_type: "first_post",
      post_object_type: "Note",
      enabled: true,
      ready: true,
    },
  ],
};
