defmodule GroupsChat.ChatsTest do
  use GroupsChat.DataCase

  alias GroupsChat.Chats

  describe "messages" do
    alias GroupsChat.Chats.Chat

    @valid_attrs %{body: "some body", key: "7488a646-e31f-11e4-aace-600308960662"}
    @update_attrs %{body: "some updated body", key: "7488a646-e31f-11e4-aace-600308960668"}
    @invalid_attrs %{body: nil, key: nil}

    def chat_fixture(attrs \\ %{}) do
      {:ok, chat} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Chats.create_chat()

      chat
    end

    test "list_messages/0 returns all messages" do
      chat = chat_fixture()
      assert Chats.list_messages() == [chat]
    end

    test "get_chat!/1 returns the chat with given id" do
      chat = chat_fixture()
      assert Chats.get_chat!(chat.id) == chat
    end

    test "create_chat/1 with valid data creates a chat" do
      assert {:ok, %Chat{} = chat} = Chats.create_chat(@valid_attrs)
      assert chat.body == "some body"
      assert chat.key == "7488a646-e31f-11e4-aace-600308960662"
    end

    test "create_chat/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Chats.create_chat(@invalid_attrs)
    end

    test "update_chat/2 with valid data updates the chat" do
      chat = chat_fixture()
      assert {:ok, %Chat{} = chat} = Chats.update_chat(chat, @update_attrs)
      assert chat.body == "some updated body"
      assert chat.key == "7488a646-e31f-11e4-aace-600308960668"
    end

    test "update_chat/2 with invalid data returns error changeset" do
      chat = chat_fixture()
      assert {:error, %Ecto.Changeset{}} = Chats.update_chat(chat, @invalid_attrs)
      assert chat == Chats.get_chat!(chat.id)
    end

    test "delete_chat/1 deletes the chat" do
      chat = chat_fixture()
      assert {:ok, %Chat{}} = Chats.delete_chat(chat)
      assert_raise Ecto.NoResultsError, fn -> Chats.get_chat!(chat.id) end
    end

    test "change_chat/1 returns a chat changeset" do
      chat = chat_fixture()
      assert %Ecto.Changeset{} = Chats.change_chat(chat)
    end
  end
end
