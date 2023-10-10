import React, { createContext, useState, useEffect } from 'react';
import Client from '@/utils/SanityClientSetup';

export const UserContext = createContext();

export const UserProvider = ({ children }) => {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  const fetchData = async ( userId ) => {
    try {
      const response = await Client.fetch(`*[_type == 'user' && _id == '${userId}']`);
      setUser(response[0]);
    } catch (err) {
      setError(err);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchData(localStorage.getItem("ImpactBridgeAuth"));
  }, []);

  const updateUserData = async () => {
    setLoading(true);
    try {
      await fetchData(localStorage.getItem("ImpactBridgeAuth"));
    } catch (err) {
      setError(err);
    } finally {
      setLoading(false);
    }
  };

  const contextValue = {
    user,
    loading,
    error,
    updateUserData,
  };


  return (
    <UserContext.Provider value={contextValue}>
      {children}
    </UserContext.Provider>
  );
};